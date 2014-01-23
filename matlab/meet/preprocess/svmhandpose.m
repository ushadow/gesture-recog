function [X, model] = svmhandpose(Y, X, frame, param)
% ARGS
% Y, X  - structure

sampleRate = param.kinectSampleRate;

dirname = param.dir;
file.Tr = fullfile(dirname, 'svm_train_hand.txt');
file.Va = fullfile(dirname, 'svm_test_hand.txt');
modelFile = [file.Tr '.model'];

model = modelFile;

dataTypes = fieldnames(Y);
for i = 1 : length(dataTypes)
  dt = dataTypes{i};
  count = outputsvmhandposedata(file.(dt), Y.(dt), X.(dt));
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
  X.(dt) = readprediction(predictFile, X.(dt));
end

end

function X = readprediction(filename, X)

prediction = importdata(filename, ' ', 1);
display(prediction.colheaders);
prediction = prediction.data(:, 2 : end)';

startNdx = 1;
for i = 1 : numel(X)
  seq = X{i};
  endNdx = startNdx + size(seq, 2) - 1;
  seq = [seq; prediction(:, startNdx : endNdx)]; %#ok<AGROW>
  startNdx = endNdx + 1;
  X{i} = seq;
end
end