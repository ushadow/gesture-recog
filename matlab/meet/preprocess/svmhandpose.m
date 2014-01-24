function [X, model] = svmhandpose(Y, X, ~, param)
% ARGS
% Y, X  - structure

% Standardize feature for SVM.
stdX = standardizefeature([], X, [], []);

dirname = param.dir;
file.Tr = fullfile(dirname, 'svm_train_hand.txt');
file.Va = fullfile(dirname, 'svm_test_hand.txt');
modelFile = [file.Tr '.model'];

model.file = modelFile;

dataTypes = fieldnames(Y);
for i = 1 : length(dataTypes)
  dt = dataTypes{i};
  count = outputsvmhandposedata(file.(dt), Y.(dt), stdX.(dt));
  display(count);
  if strcmp(dt, 'Tr')
    [count, I] = sort(count);
    I = length(count) - I + 1;
    weight = count(I);
    display(weight);
    exesvmtrain(0.03, 0.007, weight, file.(dt));
  end
  predictFile = [file.(dt) '.predict'];
  result = exesvmpredict(file.(dt), modelFile, predictFile);
  fprintf('%s result: %s', dt, result);
  [X.(dt), labels] = readprediction(predictFile, X.(dt));
end

model.labels = param.typeNames(labels);
end

function [X, labels] = readprediction(filename, X)
%% READPREDICTION add the prediction probabilities to the feature vectors.

prediction = importdata(filename, ' ', 1);
labels = cellfun(@(x) str2double(x), prediction.colheaders(2 : end));
prediction = prediction.data(:, 2 : end - 1)';

startNdx = 1;
for i = 1 : numel(X)
  seq = X{i};
  endNdx = startNdx + size(seq, 2) - 1;
  seq = [seq; prediction(:, startNdx : endNdx)]; %#ok<AGROW>
  startNdx = endNdx + 1;
  X{i} = seq;
end
end