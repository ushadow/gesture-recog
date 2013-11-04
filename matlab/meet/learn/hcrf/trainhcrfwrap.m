function hcrf = trainhcrfwrap(Y, X, param)
%
% ARGS
% Y, X  - training data

[seqs, labels] = makehcrfinput(Y, X, param.vocabularySize);

hcrfParam.nbHiddenStates = sum(cell2mat(values(param.nSMap)));
hcrfParam.optimizer = 'lbfgs';
hcrfParam.regFactorL2 = 1000;
hcrfParam.windowRecSize = 500;
hcrfParam.windowSize = 0;
hcrfParam.debugLevel = 1;
hcrfParam.modelType = 'hcrf';
hcrfParam.caption = 'HCRF';

hcrf.model = trainHCRF(seqs, labels, hcrfParam);
hcrf.param = hcrfParam;

restNDX = param.vocabularySize;
hcrf.segment = trainsegment(Y, X, restNDX, param.nRest);
end