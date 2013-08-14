function ldcrf = convertdatatrainldcrf(Y, X, param)
label = makehcrflabel(Y);
ldcrfParam.nbHiddenStates = param.nHiddenStatePerGesture;
ldcrfParam.optimizer = 'lbfgs';
ldcrfParam.windowSize = 5;
ldcrfParam.regularizationL2 = 1000;
ldcrf.model = trainLDCRF(X, label, ldcrfParam);
ldcrf.param = lcdrfParam;
end