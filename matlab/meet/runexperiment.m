function R = runexperiment(param, split, foldNdx, batchNdx, seed, data)    
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
  data = matObj.(param.dataFile);
  if size(data, 1) == 1
    data = data(1, batchNdx);
    data = data{1};
  else
    data = data(foldNdx, batchNdx);
    data = data{1}.data;
  end
else
  data = data{batchNdx};
end

if isfield(data, 'userId')
  param.userId = data.userId;
else
  param.userId = [];
end
param.fold = foldNdx;
R.param = param;

R.split = split;

Y = separatedata(data.Y, split);
X = separatedata(data.X, split);
frame = separatedata(data.frame, split);

%% Step 2: Preprocess data
%   Dimensionality reduction, standardzation, sparsification
if isfield(param, 'preprocess')
  npreprocesses = length(param.preprocess); 
  R.preprocessModel = cell(1, npreprocesses); 
  tid = tic;
  for i = 1 : npreprocesses
    fun = param.preprocess{i};
    % param can by modified and passed to the next function.
    [X, R.preprocessModel{i}, param]  = fun(Y, X, frame, param);
  end
  R.preprocessTime = toc(tid);
  display 'Done preprocess.';
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
    R.trainingTime = toc(tid);
  else 
    model = param.infModel;
    if iscell(model)
      model = model{foldNdx};
    end
    R.infModel = model;
  end

  if ~isempty(param.inference)
    tid = tic;
    [R.prediction, R.prob, R.path, R.seg] = param.inference(Y, X, frame, ...
                                     R.infModel, param);
    R.testingTime = toc(tid);
  end
  
  if ~isempty(param.postprocess)
    R.prediction = param.postprocess(R.prediction, R.path, R.seg, param);
  end

  % Step 5: Evaluate performance of prediction
  if ~isempty(param.evalFun)
    R.stat = evalclassification(Y, R.prediction, param);
  end
end
end


