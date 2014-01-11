function [X, model] = remapdepth(~, X, param)
% REMAPDEPTH the original descriptor value is inversely proportional to 
% depth, i.e., the smaller the depth, the larger the value.
%
% ARGS
% X   - cell array of feature sequences.

if isfield(X, 'Tr')
  train = X.Tr;
else
  train = X;
end

startDescNdx = param.startDescriptorNdx;
% Consider all depth pixels from all training frames.
trainAll = cell2mat(train);
trainAll = trainAll(startDescNdx : end, :);
train1 = trainAll(trainAll ~= 0);
% Minimum non-zero depth.
minValue = min(min(train1));
maxThresh = quantile(train1, 0.75) + 3 * iqr(train1);
scale = 1 / (maxThresh - minValue);

train = updatedepth(train, startDescNdx, minValue, maxThresh, scale);

if isfield(X, 'Tr')
  X.Tr = train;
else
  X = train;
end

type = {'Va', 'Te'};
for i = 1 : length(type)
  t = type{i};
  if isfield(X, t)
    X.(t) = updatedepth(X.(t), startDescNdx, minValue, maxThresh, scale);
  end
end

model.min = minValue;
model.max = maxThresh;
end

function X = updatedepth(X, startDescNdx, minValue, maxThresh, scale)
for i = 1 : length(X)
  desc = X{i}(startDescNdx : end, :);
  % Removes outliers.
  desc(desc > maxThresh) = 0;
  ndx = desc ~= 0;
  desc(ndx) = (desc(ndx) - minValue) .* scale + 0.05;
  desc = clamp(desc);
  X{i}(startDescNdx : end, :) = desc;
end
end