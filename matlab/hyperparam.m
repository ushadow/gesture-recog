function hyperParam = hyperparam(paramFromData, varargin)

hyperParam.trainIter = 1; % Training iterations

% Default values.
hyperParam.startImgFeatNDX = paramFromData.startImgFeatNDX;
hyperParam.dir = paramFromData.dir;
hyperParam.vocabularySize = paramFromData.vocabularySize;
hyperParam.subsampleFactor = paramFromData.subsampleFactor;
hyperParam.learnedModel = []; % cell array, one model for each fold.
hyperParam.dataFile = [];
hyperParam.mce = false;

% Training parameters
hyperParam.train = @trainhmmprepost;
hyperParam.maxIter = 30;
hyperParam.thresh = 0.001;

% HMM parameters
hyperParam.nSMap = containers.Map(1 : 3, [3 6 3]);
hyperParam.nM = 3;
hyperParam.combineprepost = false;
hyperParam.nRest = 1;

% Gaussian model parameters
hyperParam.XcovType = 'diag';

% AHMM parameters
hyperParam.nS = 45; % number of hidden states S.
hyperParam.L = 16;
hyperParam.resetS = true;
% inferMethod: 'fixed-interval-smoothing', 'fixed-lag-smoothing',
%              'viterbi', 'filtering'             
hyperParam.inferMethod = 'fixed-interval-smoothing';
hyperParam.Gclamp = 1;
hyperParam.clampCov = 0;
hyperParam.covPrior = 2;
hyperParam.Fobserved = 1;
hyperParam.initMeanFilePrefix = {'gesture', 44, 'rest', 1};

% Preprocess parameters.
hyperParam.preprocess = {@standardizefeature};
hyperParam.returnFeature = false;
hyperParam.nprincomp = 7; % number of principal components from image.
hyperParam.sBin = 4;
hyperParam.oBin = 9;
hyperParam.selectedFeature = [2 : 7, 11 : 13] + 18 * 3;

hyperParam.inference = @testhmmprepost;
hyperParam.evalName = {'Error', 'Leven'};
hyperParam.evalFun = {@errorperframe, @levenscore};

hyperParam.useGpu = false;
hyperParam.imageWidth = 100;
hyperParam.gSampleFactor = 1;
hyperParam.rSampleFactor = 30;

for i = 1 : 2 : length(varargin)
  hyperParam.(varargin{i}) = varargin{i + 1};
end

nmodel = length(hyperParam.nS) * length(hyperParam.L);
hyperParam.model = cell(1, nmodel);
for i = 1 : length(hyperParam.nS)
  for j = 1 : length(hyperParam.L)
    param.vocabularySize = hyperParam.vocabularySize;
    param.startImgFeatNDX = hyperParam.startImgFeatNDX;
    param.dir = hyperParam.dir;
    param.subsampleFactor = hyperParam.subsampleFactor;
    param.nRest = hyperParam.nRest;
    param.combineprepost = hyperParam.combineprepost;
    param.covPrior = hyperParam.covPrior;
    param.clampCov = hyperParam.clampCov;
    param.learnedModel = hyperParam.learnedModel;
    param.nSMap = hyperParam.nSMap;
    param.nM = hyperParam.nM;
    param.selectedFeature = hyperParam.selectedFeature;
    param.imageWidth = hyperParam.imageWidth;
    param.useGpu = hyperParam.useGpu;
    param.dataFile = hyperParam.dataFile;
    param.returnFeature = hyperParam.returnFeature;
    param.train = hyperParam.train;
    param.inference = hyperParam.inference;
    param.inferMethod = hyperParam.inferMethod;
    param.preprocess = hyperParam.preprocess;
    param.nS = hyperParam.nS(i);
    param.L = hyperParam.L(j);
    param.nprincomp = hyperParam.nprincomp;
    param.maxIter = hyperParam.maxIter;
    param.XcovType = hyperParam.XcovType;
    param.resetS = hyperParam.resetS;
    param.evalFun = hyperParam.evalFun;
    param.evalName = hyperParam.evalName;
    param.Gclamp = hyperParam.Gclamp;
    param.thresh = hyperParam.thresh;
    param.Fobserved = hyperParam.Fobserved;
    param.sBin = hyperParam.sBin;
    param.oBin = hyperParam.oBin;
    param.initMeanFilePrefix = hyperParam.initMeanFilePrefix; 
    param.mce = hyperParam.mce;
    
    ndx = (i - 1) * length(hyperParam.L) + j;
    hyperParam.model{ndx} = param;
  end
end
end