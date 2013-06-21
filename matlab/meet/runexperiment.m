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
% RETURN
% R   - if param.returnFeature is true, returns the processed feature;
%       else returns struct of result.

rng(0, 'twister');

%% Step 1: Prepare data
if ~exist('data', 'var')
  dataFileFullPath = fullfile(param.dir, param.dataFile);
  matObj = matfile(dataFileFullPath);
  data = matObj.(param.dataFile)(1, batchNDX);
  data = data{1};
end

param.userId = data.userId;
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
  data.X = [X.Tr X.Va];
  R = data;
else
%% Step 3: Train and test model, get prediction on all three splits
  if ~isempty(param.train)
    R.learnedModel = param.train(Y.Tr, X.Tr, param);
  end

  if ~isempty(param.inference)
    R.prediction = param.inference(Y, X, R.learnedModel, param);
  end

  % Step 5: Evaluate performance of prediction
  if ~isempty(param.evalFun)
    R.stat = evalclassification(Y, R.prediction, param.evalName, ...
                                param.evalFun);
  end
end
end


