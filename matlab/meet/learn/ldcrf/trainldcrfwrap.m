function ldcrf = trainldcrfwrap(Y, X, param)

ldcrfParam.nbHiddenStates = sum(cell2mat(values(param.nSMap)));
ldcrfParam.optimizer = 'lbfgs';
ldcrfParam.regFactorL2 = 1000;
ldcrfParam.windowSize = 0;
ldcrfParam.debugLevel = 1;
ldcrfParam.modelType = 'ldcrf';
ldcrfParam.caption = 'LDCRF';

restNDX = param.vocabularySize;
[labels, seqs] = segmentbyrest(Y, X, restNDX);
ldcrf.model = trainLDCRF(seqs, labels, ldcrfParam);
ldcrf.param = ldcrfParam;
ldcrf.segment = trainsegment(Y, X, restNDX, param.nRest);
end