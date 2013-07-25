function R = runexperiment(param, foldNDX, batchNDX, data)    
%% RUNEXPERIMENT runs the experiment for one fold.
% R = runexperiment(param, split, data)
%
% ARGS
% param: struct, model parameters
% foldNDX   - fold index.
% - data: struct with fields
%     - Y: cell array, label data.
%     - X: cell array, feature data.
%
% RETURNS
% R   - if param.returnFeature is true, returns the processed feature;
%       else returns struct of result.

rng(0, 'twister');

%% Step 1: Prepare data
if ~exist('data', 'var')
  % Reads data from file.
  dataFileFullPath = fullfile(param.dir, param.dataFile);
  matObj = matfile(dataFileFullPath);
  data = matObj.(param.dataFile)(1, batchNDX);
  data = data{1};
end

if isfield(data, 'userId')
  param.userId = data.userId;
else
  param.userId = [];
end
param.fold = foldNDX;
R.param = param;

split = data.split(:, foldNDX);
R.split = split;

Y.Tr = data.Y(split{1});
Y.Va = data.Y(split{2}); 

X.Tr = data.X(split{1});
X.Va = data.X(split{2});

if ~isempty(split{3})
  Y.Te = data.Y(split{3}); 
  X.Te = data.X(split{3});
end

%% Step 2: Preprocess data
%   Dimensionality reduction, standardzation, sparsification
if isfield(param, 'preprocess')
  for i = 1 : length(param.preprocess)
    fun = param.preprocess{i};
    X = fun(X, param);
  end
end

if param.returnFeature
  data.X(split{1}) = X.Tr;
  data.X(split{2}) = X.Va;
  if ~isempty(split{3})
    data.X(split{3}) = X.Te;
  end
  data.split = split;
  R = data;
else
  
%% Step 3: Train and test model, get prediction on all three splits
  if isempty(param.learnedModel) && ~isempty(param.train)
    tid = tic;
    R.learnedModel = param.train(Y.Tr, X.Tr, param);
    if isfield(param, 'jobId')
      savevariable(fullfile(param.dir, ...
          sprintf('learnedModel-%d.mat', param.jobId)), 'learnedModel', ...
          R.learnedModel);
    end
    R.trainingTime = toc(tid);
  else
    R.learnedModel = param.learnedModel{foldNDX};
  end

  if ~isempty(param.inference)
    tid = tic;
    [R.prediction, R.prob, R.path] = param.inference(Y, X, ...
        R.learnedModel, param);
    R.testingTime = toc(tid);
  end

  % Step 5: Evaluate performance of prediction
  if ~isempty(param.evalFun)
    R.stat = evalclassification(Y, R.prediction, param.evalName, ...
                                param.evalFun);
  end
end
end


