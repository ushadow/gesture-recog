function R = runexperiment(param, split, foldNDX, batchNDX, seed, data)    
%% RUNEXPERIMENT runs the experiment for one fold.
% R = runexperiment(param, split, data)
%
% ARGS
% param   - struct, model parameters
% split   - a column cell array of 3 cells with sequence indices for
%           training, testing, and optional validation.
% foldNDX - fold index.
% data    - cell array of batch data.
%
% RETURNS
% R   - if param.returnFeature is true, returns the processed feature;
%       else returns struct of result.

rng(seed, 'twister');

%% Step 1: Prepare data
if ~exist('data', 'var')
  % Reads data from file.
  dataFileFullPath = fullfile(param.dir, param.dataFile);
  matObj = matfile(dataFileFullPath);
  data = matObj.(param.dataFile)(1, batchNDX);
  data = data{1};
else
  data = data{batchNDX};
end

if isfield(data, 'userId')
  param.userId = data.userId;
else
  param.userId = [];
end
param.fold = foldNDX;
R.param = param;

R.split = split;

Y = separatedata(data.Y, split);
X = separatedata(data.X, split);

%% Step 2: Preprocess data
%   Dimensionality reduction, standardzation, sparsification
if isfield(param, 'preprocess')
  npreprocesses = length(param.preprocess); 
  R.preprocessModel = cell(1, npreprocesses); 
  tid = tic;
  for i = 1 : npreprocesses
    fun = param.preprocess{i};
    [X, R.preprocessModel{i}]  = fun(X, param);
  end
  R.preprocessTime = toc(tid);
end

if param.returnFeature
  data.X(split{1}) = X.Tr;
  data.X(split{2}) = X.Va;
  if ~isempty(split{3})
    data.X(split{3}) = X.Te;
  end
  data.split = split;
  R.data = data;
else
  
%% Step 3: Train and test model, get prediction on all three splits
  if isempty(param.infModel) && ~isempty(param.train)
    tid = tic;
    R.infModel = param.train(Y.Tr, X.Tr, param);
    if isfield(param, 'jobId')
      savevariable(fullfile(param.dir, ...
                   sprintf('model-%d.mat', param.jobId)), 'model', R);
    end
    R.trainingTime = toc(tid);
  else 
    model = param.infModel;
    if iscell(model)
      model = model{foldNDX};
    end
    R.infModel = model;
  end

  if ~isempty(param.inference)
    tid = tic;
    [R.prediction, R.prob, R.path] = param.inference(Y, X, R.infModel, ...
        param);
    R.testingTime = toc(tid);
  end
  
  if ~isempty(param.postprocess)
    [R.predictionFiltered, R.prob, R.path] = param.postprocess(...
        R.prediction, param);
  end

  % Step 5: Evaluate performance of prediction
  if ~isempty(param.evalFun)
    R.stat = evalclassification(Y, R.prediction, param.evalName, ...
                                param.evalFun);
  end
end
end


