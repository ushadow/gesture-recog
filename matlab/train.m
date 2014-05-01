function train(dirname, outputFile)
% ARGS
% outputFile  - output file name with full path. Must have .mat extension.

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
combinedData = combinedata(data);
savevariable(dataFile, 'data', data);
savevariable(combinedDataFile, 'combinedData', combinedData);

testSplit = {1 : length(combinedData{1}.Y); []; []};

hyperParam = hyperparam(combinedData{1}.param, 'dataFile', combinedDataName, ...
    'L', 6);

% fold = 1, batch = 1, seed = 1
nModels = length(hyperParam.model);
R = cell(1, nModels);
for i = 1 : nModels
  R{i} = runexperiment(hyperParam.model{i}, testSplit, 1, 1, 1, combinedData);
end

f1 = R{1}.stat('TrF1');
fprintf('Training F1 path mean = %f\n', f1.f1D);
fprintf('Training F1 pose mean = %f\n', f1.f1S);
savevariable(outputFile, 'model', R{1})
end