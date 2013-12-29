function [newX, centers] = kmeanscluster(Y, X, param)

if isfield(X, 'Tr')
  train = X.Tr;
  trainLabel = Y.Tr;
else
  train = X;
  trainLabel = Y;
end

trainMat = cell2mat(train);
startDescNdx = param.startDescriptorNdx;
descTrain = trainMat(startDescNdx : end, :);

trainLabel = cell2mat(trainLabel);
rest = descTrain(:, trainLabel(1, :) == param.vocabularySize);
gesture = descTrain(:, trainLabel(1, :) ~= param.vocabularySize);
rest = rest(:, 1 : 10 : end);
descTrainSubsampled = [rest gesture];

optKmeans = statset('UseParallel', 'always');
% centers is a a K-by-P matrix
[~, centers] = kmeans(descTrainSubsampled', param.K, ...
    'options', optKmeans, 'EmptyAction', 'drop');
centers = centers(isfinite(centers(:, 1)), :);

newTrain = computeclusterlabel(train, centers, startDescNdx);
if isfield(X, 'Tr')
  newX.Tr = newTrain;
else
  newX = newTrain;
end

if isfield(X, 'Va')
  newX.Va = computeclusterlabel(X.Va, centers, startDescNdx);
end

if isfield(X, 'Te')
  newX.Te = computeclusterlabel(X.Te, centers, startDescNdx);
end

end

function data = computeclusterlabel(data, centers, startDescNdx)
%%
% ARGS
% data  - cell array

for i = 1 : numel(data)
  old = data{i};
  labels = knnsearch(centers, old(startDescNdx : end, :)');
  data{i} = [old(1 : startDescNdx - 1, :); labels'];
end
end