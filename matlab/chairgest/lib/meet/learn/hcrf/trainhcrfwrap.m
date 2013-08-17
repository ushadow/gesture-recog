function hcrf = trainhcrfwrap(Y, X, param)
%
% ARGS
% Y, X  - training data

[seqs, labels] = makehcrfinput(Y, X, param.vacabularySize);

hcrfParam.nbHiddenStates = sum(cell2mat(values(param.nSMap)));
hcrfParam.optimizer = 'lbfgs';
hcrfParam.regularizationL2 = 10000;
hcrfParam.windowRecSize = 500;

hcrf.model = trainHCRF(seqs, labels, hcrfParam);
hcrf.param = hcrfParam;

restNDX = param.vocabularySize;
hcrf.segment = trainsegment(Y, X, restNDX, param.nRest);
end