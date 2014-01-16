function hyperParam = hyperparam(paramFromData, varargin)

hyperParam.trainIter = 1; % Training iterations

% Default values.
hyperParam.startDescriptorNdx = paramFromData.startDescriptorNDX;
hyperParam.dir = paramFromData.dir;
hyperParam.vocabularySize = paramFromData.vocabularySize;
hyperParam.subsampleFactor = paramFromData.subsampleFactor;
hyperParam.kinectSampleRate = paramFrameData.kinectSampleRate;

hyperParam.infModel = []; % cell array, one model for each fold.
hyperParam.dataFile = [];
hyperParam.mce = false;

% Preprocess parameters.
hyperParam.preprocess = {@pcaimage, @standardizefeature};
hyperParam.returnFeature = false;
hyperParam.nprincomp = 23; % number of principal components from image.
hyperParam.sBin = 4;
hyperParam.oBin = 9;
hyperParam.selectedFeature = [2 : 7, 11 : 13] + 18 * 3;

% Training parameters
hyperParam.train = @trainhmm;
hyperParam.maxIter = 30;
hyperParam.thresh = 0.001;

% HMM parameters
hyperParam.nSMap = containers.Map(1 : 3, [3 6 3]);
hyperParam.nM = 1; % Number of mixtures.
hyperParam.nS = 6;
hyperParam.combineprepost = false;
hyperParam.nRest = 1; % Number of mixtures for rest state.

% Gaussian model parameters
hyperParam.XcovType = 'diag';

% AHMM parameters
hyperParam.resetS = true;
hyperParam.Gclamp = 1;
hyperParam.clampCov = 0;
hyperParam.covPrior = 2;
hyperParam.Fobserved = 1;
hyperParam.initMeanFilePrefix = {'gesture', 44, 'rest', 1};

% Inference parameters.
hyperParam.inference = @testhmm;
% inferMethod: 'fixed-interval-smoothing', 'fixed-lag-smoothing',
%              'viterbi', 'filtering'             
hyperParam.inferMethod = 'fixed-lag-smoothing';
hyperParam.L = 0; % Lag time.

% Evaluation parameters.
hyperParam.evalName = {'Error', 'Leven'};
hyperParam.evalFun = {@errorperframe @levenscore};

hyperParam.useGpu = false;

for i = 1 : 2 : length(varargin)
  hyperParam.(varargin{i}) = varargin{i + 1};
end

nmodel = length(hyperParam.nS) * length(hyperParam.L);
hyperParam.model = cell(1, nmodel);
for i = 1 : length(hyperParam.nS)
  for j = 1 : length(hyperParam.L)
    param.vocabularySize = hyperParam.vocabularySize;
    param.startDescriptorNDX = hyperParam.startDescriptorNDX;
    param.dir = hyperParam.dir;
    param.subsampleFactor = hyperParam.subsampleFactor;
    param.nRest = hyperParam.nRest;
    param.combineprepost = hyperParam.combineprepost;
    param.covPrior = hyperParam.covPrior;
    param.clampCov = hyperParam.clampCov;
    param.infModel = hyperParam.infModel;
    param.nSMap = hyperParam.nSMap;
    param.nM = hyperParam.nM;
    param.selectedFeature = hyperParam.selectedFeature;
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