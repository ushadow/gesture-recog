function train(dirname, outputPath)
combinedDataName = 'combinedData';

dataFile = fullfile(dirname, 'data.mat');
combinedDataFile = fullfile(dirname, [combinedDataName '.mat']);

%% Process and save data.
if exist(dataFile, 'file')
  load(dataFile);
else 
  data = [];
end
data = prepdata(dirname, 'prevData', data);
combinedData = {combinedata(data)};
savevariable(dataFile, 'data', data);
savevariable(combinedDataFile, 'combinedData', combinedData);

testSplit = {1 : length(combinedData{1}.Y); []; []};

jobParam = jobparam;
hyperParam = hyperparam(combinedData{1}.param, 'dataFile', combinedDataName);

% fold = 1, batch = 1, seed = 1
nModels = length(hyperParam.model);
R = cell(1, nModels);
for i = 1 : nModels
  R{i} = runexperiment(hyperParam.model{i}, testSplit, 1, 1, 1, combinedData);
end

fprintf('Training FrameError = %f\n', R{1}.stat('TrFrameError'));
fprintf('Training F1 = %f\n', R{1}.stat('TrF1').f1);
savevariable(outputPath, 'model', R{1})
end