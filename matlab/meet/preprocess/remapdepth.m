function [X, model] = remapdepth(X, ~)
% REMAPDEPTH the original value is inversely proportional to depth. The 
% smaller the depth, the larger the value.
%
% ARGS
% X   - image vector or image matrix

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

train = updatedepth(train, minValue, maxThresh, scale);

if isfield(X, 'Tr')
  X.Tr = train;
else
  X = train;
end

type = {'Va', 'Te'};
for i = 1 : length(type)
  t = type{i};
  if isfield(X, t)
    X.(t) = updatedepth(X.(t), minValue, maxThresh, scale);
  end
end

model.min = minValue;
model.max = maxThresh;
end

function X = updatedepth(X, minValue, maxThresh, scale)
for i = 1 : length(X)
  % Removes outliers.
  X{i}(X{i} > maxThresh) = 0;
  NDX = X{i} ~= 0;
  X{i}(NDX) = (X{i}(NDX) - minValue) .* scale + 0.05;
  X{i} = clamp(X{i});
end
end