dirname = 'G:\data\stand_hog1';
combinedDataName = 'combinedData';
% 0: don't load data
dataOption = 0;

dataFile = fullfile(dirname, 'data.mat');
combinedDataFile = fullfile(dirname, [combinedDataName '.mat']);

%% Process and save data.
switch dataOption
  case 1
    if exist(dataFile, 'file')
      load(dataFile);
    else 
      data = [];
    end
    data = prepdata(dirname, 'prevData', data);
    combinedData = {combinedata(data)};
    savevariable(dataFile, 'data', data);
    savevariable(combinedDataFile, 'combinedData', combinedData);
  case 2
    % Load data.
    load(combinedDataFile); 
end

testSplit = {[1 : 2, 4, 6, 8, 10, 11, 12]; [3, 5, 7, 9]; []};

jobParam = jobparam;
hyperParam = hyperparam(combinedData{1}.param, 'dataFile', combinedDataName);

% fold = 1, batch = 1, seed = 1
nModels = length(hyperParam.model);
R = cell(1, nModels);
for i = 1 : nModels
  R{i} = runexperiment(hyperParam.model{i}, testSplit, 1, 1, 1, combinedData);
end

fprintf('Training F1 = %f\n', R{1}.stat('TrF1').f1);
fprintf('Training FrameError = %f\n', R{1}.stat('TrFrameError'));
fprintf('Testing F1 = %f\n', R{1}.stat('VaF1').f1);
fprintf('Testing FrameError = %f\n', R{1}.stat('VaFrameError'));