function hyperParam = hyperparam(paramFromData, varargin)

% Default values.
hyperParam.startImgFeatNDX = paramFromData.startImgFeatNDX;
hyperParam.dir = paramFromData.dir;
hyperParam.vocabularySize = paramFromData.vocabularySize;
hyperParam.learnedModel = []; % cell array, one model for each fold.

% HMM parameters
hyperParam.nSMap = containers.Map(1 : 3, [3 7 3]);
hyperParam.nM = 3;
hyperParam.combineprepost = false;

% HMM and AHMM parameters
hyperParam.XcovType = 'diag';

hyperParam.nS = 45; % number of hidden states S.
hyperParam.L = 16;
hyperParam.nprincomp = 7; % number of principal components from image.
hyperParam.resetS = true;

% inferMethod: 'fixed-interval-smoothing', 'fixed-lag-smoothing',
%              'viterbi', 'filtering'             
hyperParam.inferMethod = 'fixed-interval-smoothing';
hyperParam.train = @trainhmmprepost;
hyperParam.inference = @testhmm;
hyperParam.preprocess = {};
hyperParam.maxIter = 10;
hyperParam.evalName = {'Error', 'Leven'};
hyperParam.evalFun = {@errorperframe, @levenscore};
hyperParam.Gclamp = 1;
hyperParam.thresh = 0.001;
hyperParam.sBin = 4;
hyperParam.oBin = 9;
hyperParam.Fobserved = 1;
hyperParam.initMeanFilePrefix = {'gesture', 44, 'rest', 1};
hyperParam.returnFeature = false;
hyperParam.dataFile = 'dsImuStd';
hyperParam.useGpu = false;
hyperParam.imageWidth = 100;
hyperParam.selectedFeature = [2 : 7, 11 : 13] + 18 * 3;
hyperParam.clampCov = 0;
hyperParam.covPrior = 2;
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
    
    ndx = (i - 1) * length(hyperParam.L) + j;
    hyperParam.model{ndx} = param;
  end
end
end