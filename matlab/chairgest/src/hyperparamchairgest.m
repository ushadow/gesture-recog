function hyperParam = hyperparamchairgest(paramFromData, varargin)

hyperParam.trainIter = 1; % Training iterations

% Default values.
hyperParam.startDescriptorNdx = paramFromData.startImgFeatNDX;
hyperParam.dir = paramFromData.dir;
hyperParam.vocabularySize = paramFromData.vocabularySize;
hyperParam.subsampleFactor = paramFromData.subsampleFactor;
hyperParam.infModel = []; % cell array, one model for each fold.
hyperParam.dataFile = [];
hyperParam.mce = false;
hyperParam.imageWidth = paramFromData.imgWidth;

% Preprocess parameters.
% @denoise @remapdepth @resize @kmeanscluster @learndict @standardizefeature
hyperParam.preprocess = {@standardizefeature};
hyperParam.channels = 1;
hyperParam.filterWinSize = 5;
hyperParam.returnFeature = false;
hyperParam.nprincomp = 12; % number of principal components from image.
hyperParam.pcaRange = 1 : 12;
hyperParam.sBin = 4;
hyperParam.oBin = 9;
hyperParam.resizeWidth = 16;
% For kinect and xsens data, 1 : 3 is relative position, 4 : 12 is xsens
% data
hyperParam.selectedFeature = 1 : 9; %[2 : 7, 11 : 13] + 18 * 3; %Xsens
hyperParam.K = 300; % number of dictinoary terms
hyperParam.nFolds = 4;

% Training parameters
hyperParam.train = @trainldcrfwrap;
hyperParam.trainSegment = true;
hyperParam.maxIter = 1000; %hmm: 30
hyperParam.thresh = 0.001;
hyperParam.regFactorL2 = 100;
hyperParam.segmentFeatureNdx = 1 : hyperParam.startDescriptorNdx - 1;

% HMM parameters
hyperParam.nSMap = containers.Map(1 : 3, [3 6 3]);
hyperParam.nS = 6; % number of hidden states S.
hyperParam.nM = 6;
hyperParam.combineprepost = false;
hyperParam.nRest = 1; % number of mixtures for rest position

% Gaussian model parameters
hyperParam.XcovType = 'diag';

% AHMM parameters
hyperParam.L = 16;
hyperParam.resetS = true;
hyperParam.Gclamp = 1;
hyperParam.clampCov = 0;
hyperParam.covPrior = 2;
hyperParam.Fobserved = 1;
hyperParam.initMeanFilePrefix = {'gesture', 44, 'rest', 1};

% Inference, test parameters
hyperParam.inference = @testldcrfwrap;
% inferMethod: 'fixed-interval-smoothing', 'fixed-lag-smoothing',
%              'viterbi', 'filtering'             
hyperParam.inferMethod = 'viterbi';
hyperParam.testsegment = @segmentbymodel;
hyperParam.combinehmmparam = @combinehmmparamwithrest;

% Post process
hyperParam.postprocess = {};

hyperParam.evalName = {};
hyperParam.evalFun = {};

hyperParam.useGpu = false;
hyperParam.gSampleFactor = 1;
hyperParam.rSampleFactor = 30;

for i = 1 : 2 : length(varargin)
  hyperParam.(varargin{i}) = varargin{i + 1};
end

nmodel = length(hyperParam.nS) * length(hyperParam.L);
hyperParam.model = cell(1, nmodel);
allParams = fieldnames(hyperParam);
validateParams = {'nS', 'L'};
diff = setdiff(allParams, validateParams);
for i = 1 : length(hyperParam.nS)
  for j = 1 : length(hyperParam.L)
    param.nS = hyperParam.nS(i);
    param.L = hyperParam.L(j);
    for k = 1 : numel(diff)
      param.(diff{k}) = hyperParam.(diff{k});
    end
    ndx = (i - 1) * length(hyperParam.L) + j;
    hyperParam.model{ndx} = param;
  end
end
end