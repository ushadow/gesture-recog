dirname = 'H:\yingyin\chairgest_saliencexsens4';
dataFile = fullfile(dirname, 'data.mat');

%% Process data and save.
%data = prepdatachairgest(dirname, 'gtSensorType', 'Kinect', 'subsampleFactor', 1);
%combinedData = {combinedata(data)};
%savevariable(dataFile, 'data', combinedData);

%% Load data.
combinedData = load(dataFile);
combinedData = combinedData.data;

%split = getsessionsplit(dirname, 'Kinect');
%split = getusersplit(data, 3);
%savevariable(fullfile(dirname, 'usersplit.mat'), 'userSplit', split);

%% Load user split.
split = load(fullfile(dirname, 'usersplit.mat')); 
split = split.userSplit;

%testSplit = {1 : 40; 41; []};
testSplit = {1; 2; []};

hyperParam = hyperparamchairgest(combinedData{1}.param, 'dataFile', 'data');
jobParam = jobparam;

% Test.
%R = runexperiment(hyperParam, testSplit(:, 1), 1, 1, 1, combinedData);

% Parallel run.
runexperimentbatch(combinedData, split, hyperParam, jobParam);

%outputchairgest(dsKinectXsens{1}, job247_output, 'hmm-nM-6-247-1session1user', 'yingyin', gesturelabel)