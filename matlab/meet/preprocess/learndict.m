function [newX, model] = learndict(~, X, param)

if isfield(X, 'Tr')
  train = X.Tr;
else
  train = X;
end

startDescriptorNdx = param.startDescriptorNdx;

% train is a d x n matrix where d is the feature dimension and n is the 
% number of samples.
trainMat = descriptorfeature(train, startDescriptorNdx);

% Dictionary learning parameters.
dlParams.K = param.K;
dlParams.lambda = 0.1;
dlParams.iter = 100;
dlParams.verbose = true;
dlParams.approx = 0;

D = mexTrainDL(trainMat, dlParams);

newTrain = computenewfeature(train, startDescriptorNdx, D, dlParams);
if isfield(X, 'Tr')
  newX.Tr = newTrain;
else
  newX = newTrain;
end

if isfield(X, 'Va')
  newX.Va = computenewfeature(X.Va, startDescriptorNdx, D, dlParams);
end

if isfield(X, 'Te')
  newX.Te = computenewfeature(X.Te, startDescriptorNdx, D, dlParams);
end

model.D = D;
end

function data = computenewfeature(data, startDescNdx, D, dlParams)
% ARGS
% data  - cell array of dense matrices.

descriptor = descriptorfeature(data, startDescNdx);
alpha = mexLasso(descriptor, D, dlParams);
startNdx = 1;
for i = 1 : numel(data)
  old = data{i};
  endNdx = startNdx + size(old, 2) - 1;
  data{i} = full([old(1 : startDescNdx - 1, :); alpha(:, startNdx : endNdx)]);
  startNdx = endNdx + 1;
end
end