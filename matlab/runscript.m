dirname = 'G:\data\stand_hog1';
combinedDataName = 'combinedData';

dataFile = fullfile(dirname, 'data.mat');
combinedDataFile = fullfile(dirname, [combinedDataName '.mat']);
%combinedData = eval(combinedDataName);

%% Process and save data.
% data = prepdata(dirname);
% combinedData = {combinedata(data)};
% savevariable(fullfile(dirname, 'data.mat'), 'data', data);
% savevariable(fullfile(dirname, 'combinedData.mat'), 'combinedData', ...
%              combinedData);

%% Load data.
%load(combinedDataFile);

testSplit = {[1 : 2, 4, 6]; [3, 5, 7]; []};

jobParam = jobparam;
hyperParam = hyperparam(combinedData{1}.param, 'dataFile', combinedDataName);

% fold = 1, batch = 1, seed = 1
nModels = length(hyperParam.model);
R = cell(1, nModels);
for i = 1 : nModels
  R{i} = runexperiment(hyperParam.model{i}, testSplit, 1, 1, 1, combinedData);
end

%runexperimentbatch(combinedData, split, hyperParam, jobParam);
%outputchairgest(dsKinectXsens{1}, job247_output, 'hmm-nM-6-247-1session1user', 'yingyin', gesturelabel)