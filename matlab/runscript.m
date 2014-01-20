dirname = 'G:\data\stand_hog';
combinedDataName = 'combinedData';

dataFile = fullfile(dirname, 'data.mat');
combinedDataFile = fullfile(dirname, [combinedDataName '.mat']);
%combinedData = eval(combinedDataName);

%% Process and save data.
%data = prepdata(dirname);
%combinedData = {combinedata(data)};
%savevariable(fullfile(dirname, 'data.mat'), 'data', data);
%savevariable(fullfile(dirname, 'combinedData.mat'), 'combinedData', ...
%              combinedData);

%% Load data.
%load(combinedDataFile);

testSplit = {1; 2; []};

jobParam = jobparam;
hyperParam = hyperparam(combinedData{1}.param, 'dataFile', combinedDataName);

% fold = 1, batch = 1, seed = 1
R = runexperiment(hyperParam, testSplit, 1, 1, 1, combinedData);

%runexperimentbatch(combinedData, split, hyperParam, jobParam);
%outputchairgest(dsKinectXsens{1}, job247_output, 'hmm-nM-6-247-1session1user', 'yingyin', gesturelabel)