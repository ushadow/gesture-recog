function ldcrfmasked = trainldcrfmaskedwrap(Y, X, param)

ldcrfParam.nbHiddenStates = param.nS;
ldcrfParam.optimizer = 'lbfgs';
ldcrfParam.regFactorL2 = 1000;
ldcrfParam.windowSize = 0;
ldcrfParam.debugLevel = 0;
ldcrfParam.modelType = 'ldcrfmasked';
ldcrfParam.caption = 'LDCRFMasked';
ldcrfParam.transMatMask = makepreposttransmask(ldcrfParam.nbHiddenStates, ...
    param.vocabularySize - 1);

restNDX = param.vocabularySize;
[labels, seqs] = segmentbyrest(Y, X, restNDX);
% Labels to LDCRFMasked are zero-based.
labels = cellfun(@(x) x - 1, labels, 'UniformOutput', false);

ldcrfmasked.model = trainLDCRFMasked(seqs, labels, ldcrfParam);
ldcrfmasked.param = ldcrfParam;
ldcrfmasked.segment = trainsegment(Y, X, restNDX, param.nRest);
end
