dirname = 'H:\yingyin\chairgest_saliencexsens4';
dataFile = fullfile(dirname, 'data.mat');
combinedDataFile = fullfile(dirname, 'combinedData.mat');

%% Process data and save.
%data = prepdatachairgest(dirname, 'gtSensorType', 'Xsens', 'subsampleFactor', 1);
%savevariable(dataFile, 'data', data);
%combinedData = {combinedata(data)};
%savevariable(combinedDataFile, 'combinedData', combinedData);
%split = getusersplit(data, 3);
%savevariable(fullfile(dirname, 'usersplit.mat'), 'userSplit', split);

%% Load data.
% load(combinedDataFile);
% split = load(fullfile(dirname, 'usersplit.mat')); 
% split = split.userSplit;

testSplit = {1; 2; []};

hyperParam = hyperparamchairgest(combinedData{1}.param, 'dataFile', 'combinedData');
jobParam = jobparam;

% Test.
R = runexperiment(hyperParam, testSplit(:, 1), 1, 1, 1, combinedData);

% Parallel run.
% runexperimentbatch(combinedData, split, hyperParam, jobParam);

%outputchairgest(dsKinectXsens{1}, job247_output, 'hmm-nM-6-247-1session1user', 'yingyin', gesturelabel)