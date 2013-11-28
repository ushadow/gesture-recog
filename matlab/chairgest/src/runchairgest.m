%dirname = 'H:\yingyin\chairgest_salience';
%dataFile = fullfile(dirname, 'data.mat');

%data = prepdatachairgest(dirname, 'gtSensorType', 'Kinect', 'subsampleFactor', 1);
%combinedData = {combinedata(data)};
%savevariable(dataFile, 'data', combinedData);

%combinedData = load(dataFile);
%combinedData = combinedData.data;

%split = getsessionsplit(dirname, 'Kinect');
%split = getusersplit(data, 3);
%savevariable(fullfile(dirname, 'usersplit.mat'), 'userSplit', split);
%split = load(fullfile(dirname, 'usersplit.mat')); 
%split = split.userSplit;

testSplit = {1 : 40; 41; []};

hyperParam = hyperparamchairgest(combinedData{1}.param, 'dataFile', 'data', ...
  'nM', 6);
jobParam = jobparam;
R = runexperiment(hyperParam, testSplit(:, 1), 1, 1, 1, combinedData);
%runexperimentbatch(combinedData, split, hyperParam, jobParam);
%outputchairgest(dsKinectXsens{1}, job247_output, 'hmm-nM-6-247-1session1user', 'yingyin', gesturelabel)