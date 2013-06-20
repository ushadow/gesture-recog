function hyperParam = hyperparam(paramFromData, varargin)

% Default values.
hyperParam.nS = 50; % number of hidden states S.
hyperParam.L = 16;
hyperParam.nprincomp = 11; % total number of principal components.
hyperParam.XcovType = 'diag';
hyperParam.resetS = false;
hyperParam.inferMethod = 'fixed-interval-smoothing';
hyperParam.train = @trainahmm;
hyperParam.inference = @inferenceahmm;
hyperParam.preprocess = {@selectfeature @standardizefeature};
hyperParam.maxIter = 7;
hyperParam.evalName = {'Error', 'Leven'};
hyperParam.evalFun = {@errorperframe, @levenscore};
hyperParam.Gclamp = 1;
hyperParam.thresh = 0.001;
hyperParam.sBin = 4;
hyperParam.oBin = 9;
hyperParam.Fobserved = 1;
hyperParam.initFromFile = false;
hyperParam.returnFeature = true;
hyperParam.dataFile = 'dsImu';
hyperParam.useGpu = false;
hyperParam.imageWidth = 256;
hyperParam.selectedFeature = [2 : 7, 11 : 13];

hyperParam.startImgFeatNDX = paramFromData.startImgFeatNDX;
hyperParam.dir = paramFromData.dir;
hyperParam.vocabularySize = paramFromData.vocabularySize;

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
    param.initFromFile = hyperParam.initFromFile; 
    
    ndx = (i - 1) * length(hyperParam.L) + j;
    hyperParam.model{ndx} = param;
  end
end
end