function X = remapdepth(X, ~)
%
% Args:
% - X: image vector or image matrix

if isfield(X, 'Tr')
  train = X.Tr;
else
  train = X;
end

% Consider all features from all frames.
trainAll = cell2mat(train);
train1 = trainAll(trainAll ~= 0);
% Minimum non-zero depth.
minValue = min(min(train1));
maxThresh = quantile(train1, 0.75) + 3 * iqr(train1);
scale = 1 / (maxThresh - minValue);

train = updatedepth(train, maxThresh, scale);

if isfield(X, 'Tr')
  X.Tr = train;
else
  X = train;
end

type = {'Va', 'Te'};
for i = 1 : length(type)
  t = type{i};
  if isfield(X, t)
    X.(t) = updatedepth(X.(t), maxThresh, scale);
  end
end
end

function X = updatedepth(X, maxThresh, scale)
for i = 1 : length(X)
  % Removes outliers.
  X{i}(X{i} > maxThresh) = 0;
  NDX = X{i} ~= 0;
  X{i}(NDX) = (maxThresh - X{i}(NDX)) .* scale + 0.05;
  X{i} = clamp(X{i});
end
end