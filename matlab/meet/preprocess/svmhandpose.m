function [X, model, param] = svmhandpose(Y, X, ~, param)
% ARGS
% Y, X  - structure

% Standardize feature for SVM.
stdX = standardizefeature([], X, [], []);

dirname = param.dir;
gestureType = param.gestureType;
file.Tr = fullfile(dirname, 'svm_train_hand.txt');
file.Va = fullfile(dirname, 'svm_test_hand.txt');
modelFile = [file.Tr '.model'];

model.file = modelFile;

dataTypes = fieldnames(Y);
for i = 1 : length(dataTypes)
  dt = dataTypes{i};
  [count, label] = outputsvmhandposedata(file.(dt), Y.(dt), stdX.(dt), gestureType);
  display(count);
  if strcmp(dt, 'Tr')
    [sorted, I] = sort(count);
    count(I) = sorted(end : -1 : 1);
    display(count);
    display(label);
    exesvmtrain(8, 0.03, count, label, file.(dt));
  end
  predictFile = [file.(dt) '.predict'];
  result = exesvmpredict(file.(dt), modelFile, predictFile);
  fprintf('%s result: %s', dt, result);
  [X.(dt), labels] = readprediction(predictFile, Y.(dt), X.(dt), param.hasDiscrete, ...
      gestureType);
end

model.labels = labels;
featureLength = size(X.Tr{1}, 1);
param.pcaRange = 1 : featureLength;
param.nprincomp = featureLength - 3;
end

function [X, labels] = readprediction(filename, Y, X, hasDiscreate, gestureType)
%% READPREDICTION add the prediction probabilities to the feature vectors.
%
% ARGS
% X   - cell array.

prediction = importdata(filename, ' ', 1);
labels = cellfun(@(x) str2double(x), prediction.colheaders(2 : end));

nLabel = size(prediction.data, 2);
if hasDiscreate
  ndx = 1;
else
  ndx = 2 : nLabel - 1;
end

prediction = prediction.data(:, ndx)'; % transposed
 
startNdx = 1;
for i = 1 : numel(X)
  seq = X{i};
  [d, n] = size(seq);
  I = find(strcmp(gestureType(Y{i}(1, :)), 'S'));
  endNdx = startNdx + length(I) - 1;
  newSeq = ones(d + 1, n) * length(gestureType);
  newSeq(1 : d, :) = seq;
  newSeq(end, I) = prediction(:, startNdx : endNdx); 
  startNdx = endNdx + 1;
  X{i} = newSeq;
end
end