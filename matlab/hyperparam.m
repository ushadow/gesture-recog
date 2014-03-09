function hyperParam = hyperparam(paramFromData, varargin)

% Parameters from data
fn = fieldnames(paramFromData);
for i = 1 : numel(fn)
  hyperParam.(fn{i}) = paramFromData.(fn{i});
end

gestureDefDir = 'C:\Users\yingyin';
[hyperParam.gestureLabel, hyperParam.gestureDict, ...
    hyperParam.gestureType, hyperParam.repeat, hyperParam.nS] = ...
    gesturelabel(gestureDefDir);

% Default values.
hyperParam.trainIter = 1; % Training iterations
hyperParam.infModel = []; % cell array, one model for each fold.
hyperParam.dataFile = [];
validateParams = {};

% Preprocess parameters.
% @denoise @remapdepth @resize @kmeanscluster @learndict @standardizefeature
hyperParam.preprocess = {@fastpca @standardizefeature};
hyperParam.channels = [1 2];
hyperParam.filterWinSize = 5;
hyperParam.returnFeature = false;
hyperParam.nprincomp = 15; % number of principal components from image.
hyperParam.pcaRange = 10 : 450;
hyperParam.sBin = 4;
hyperParam.oBin = 9;
hyperParam.resizeWidth = 15;
% For kinect and xsens data, 1 : 3 is relative position, 4 : 12 is xsens
% data
%[2 : 7, 11 : 13] + 18 * 3; %Xsens
hyperParam.selectedFeature = 10 : 450; 
hyperParam.K = 300; % number of dictinoary terms
hyperParam.nFolds = 1; % number of folds in HOG.

% Training parameters
hyperParam.train = @trainhmm;
hyperParam.trainSegment = true;
hyperParam.maxIter = 30; %ldcrf: 1000; hmm: 30
hyperParam.thresh = 0.001;
hyperParam.regFactorL2 = 100;
hyperParam.segmentFeatureNdx = 1 : hyperParam.startDescriptorNdx - 1;

% HMM parameters
hyperParam.nSMap = containers.Map(1 : 3, [3 6 3]);
hyperParam.nM = [6 12];
hyperParam.combineprepost = false;
hyperParam.nRest = 1; % number of mixtures for rest position
% Gaussian model parameters
hyperParam.XcovType = 'diag';

% AHMM parameters
hyperParam.resetS = true;
hyperParam.Gclamp = 1;
hyperParam.clampCov = 0;
hyperParam.covPrior = 2;
hyperParam.Fobserved = 1;
hyperParam.initMeanFilePrefix = {'gesture', 44, 'rest', 1};

% Inference, test parameters
hyperParam.inference = @testhmm;
% inferMethod: 'fixed-interval-smoothing', 'fixed-lag-smoothing',
%              'viterbi', 'filtering'             
hyperParam.inferMethod = 'fixed-lag-smoothing';
hyperParam.L = 8;
hyperParam.testsegment = @segmentbymodel;
hyperParam.combinehmmparam = @combinehmmparamwithrest;

% Post process
hyperParam.postprocess = {};

hyperParam.evalName = {'F1'};
hyperParam.evalFun = {@f1};

hyperParam.useGpu = false;
hyperParam.gSampleFactor = 1;
hyperParam.rSampleFactor = 30;

for i = 1 : 2 : length(varargin)
  hyperParam.(varargin{i}) = varargin{i + 1};
end

allParams = fieldnames(hyperParam);
diff = setdiff(allParams, validateParams);

if ~isempty(validateParams)
  v = cellfun(@(x) hyperParam.(x), validateParams, 'UniformOutput', false);
  g = cell(1, length(v));
  [g{:}] = ndgrid(v{:});
  nModels = numel(g{1});
else
  nModels = 1;
end
hyperParam.model = cell(1, nModels);
for i = 1 : nModels
  for k = 1 : length(validateParams)
    param.(validateParams{k}) = g{k}(i);
  end
  for k = 1 : length(diff)
    param.(diff{k}) = hyperParam.(diff{k});
  end
  hyperParam.model{i} = param;
end
end