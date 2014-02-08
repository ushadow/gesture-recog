dirname = 'G:\data\stand_hog1';
combinedDataName = 'combinedData';
processData = true;

dataFile = fullfile(dirname, 'data.mat');
combinedDataFile = fullfile(dirname, [combinedDataName '.mat']);

%% Process and save data.
if processData
  data = prepdata(dirname);
  combinedData = {combinedata(data)};
  savevariable(dataFile, 'data', data);
  savevariable(combinedDataFile, 'combinedData', combinedData);
else
  % Load data.
  load(combinedDataFile); %#ok<UNRCH>
end

testSplit = {1 : length(combinedData{1}.Y); []; []};

jobParam = jobparam;
hyperParam = hyperparam(combinedData{1}.param, 'dataFile', combinedDataName);

% fold = 1, batch = 1, seed = 1
nModels = length(hyperParam.model);
R = cell(1, nModels);
for i = 1 : nModels
  R{i} = runexperiment(hyperParam.model{i}, testSplit, 1, 1, 1, combinedData);
end

fprintf('Training error = %f\n', R{1}.stat('TrError'));
savevariable(fullfile('G:\workspace\handinput\GesturesViewer\bin\x64', 'model.mat'), 'model', R{1})