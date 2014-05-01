% Set dirname, for example
% dirname = 'G:\data\yang_hog';

testSplit = {1 : 2; [3 4]; []};

jobParam = jobparam;
hyperParam = hyperparam(dataSeg{1}.param, 'dataFile', 'dataSeg', 'L', 7);

runexperimentbatch(dataSeg, testSplit, hyperParam, jobParam);