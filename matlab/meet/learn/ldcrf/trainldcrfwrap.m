function ldcrf = trainldcrfwrap(Y, X, param)

ldcrfParam.nbHiddenStates = param.nS;
ldcrfParam.optimizer = 'lbfgs';
ldcrfParam.regFactorL2 = 1000;
ldcrfParam.windowSize = 0;
ldcrfParam.debugLevel = 0;
ldcrfParam.modelType = 'ldcrf';
ldcrfParam.caption = 'LDCRF';

restNDX = param.vocabularySize;
[labels, seqs] = segmentbyrest(Y, X, restNDX);
% Labels to LDCRF are zero-based.
labels = cellfun(@(x) x - 1, labels, 'UniformOutput', false);
ldcrf.model = trainLDCRF(seqs, labels, ldcrfParam);
ldcrf.param = ldcrfParam;
ldcrf.segment = trainsegment(Y, X, restNDX, param.nRest);
end