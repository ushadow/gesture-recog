function [newX, sortedEigVal, pc] = pcaimage(X, param)
%% PCAIMAGE PCA for image features.
%
% [eigHand handFeature rawFeature H] = eigenhand(X) 
% 
% Args
% -X: observed data or a struct with Tr, Va and Te data. Each 
%     data is a cell array and each cell is a feature vector.
% -param: a struct with the following fields
%   -nhandFet: number of hand features should be included in the result.
%               This determineds the number of eigen hand used.
%   -startHandFetNDX: the start index of the hand image in the feature 
%                     vector.
%
% Returns
% newX: if X is a structure of train, validate, test data, newX is also a
%       structure with the same fields with eigenhand features. If X is a 
%       cell array, newX is also a cell array.
% sortedEigVal: a vector of sorted eigenvalues correspoinding to the 
%               eigHand.
% eigHand: a npixel x K matrix where K is the number of eigenvectors chosen.
% handFeature: K x nframe matrix.
% rawFeature: all hand images in column vectors.

if isfield(X, 'Tr')
  train = X.Tr;
else
  train = X;
end

% Number of principal components to use for image.
startImgFeatNDX = param.startImgFeatNDX;
k = param.nprincomp - param.startImgFeatNDX + 1;

[A, mean] = normalizefeature(train, startImgFeatNDX);

% Let u be the eigenhand. We want to find AA' * u = lamda * u, but AA' is a 
% large matrix because the dimension of the feature vector is probabily 
% larger than the nunmber of example. So we compute A'* A = V * Dv * V'.
% (A * A')^2 = AV * Dv * V'A' = U * Du^2 * U'. We have A' * A * v = dv * v.
% A * A' * (Av) = dv * (Av) = dv * u where u = A * v. 
[D, n] = size(A);
if D > n
  C = A' * A;
  if param.useGpu > 0
    C = gpuArray(C);
  end
  tic;
  [eigVec, eigVal] = eig(C);
  toc;
  if param.useGpu
    eigVec = gather(eigVec);
    eigVal = gather(eigVal);
  end
  [sortedEigVec, sortedEigVal] = getprincomp(eigVec, eigVal, k);
  pc = normc(A * sortedEigVec); % npixel x neigenhand
else
  C = A * A';
  if param.useGpu > 0
    C = gpuArray(C);
  end
  tic;
  [eigVec, eigVal] = eig(C);
  toc;
  if param.useGpu
    eigVec = gather(eigVec);
    eigVal = gather(eigVal);
  end
  [pc, sortedEigVal] = getprincomp(eigVec, eigVal, k);
end
newFeature = updatedata(train, pc, startImgFeatNDX, ...
                        'normalized', A);

if isfield(X, 'Tr')
  newX.Tr = newFeature;
else
  newX = newFeature;
end

if isfield(X, 'Va')
  newX.Va = updatedata(X.Va, pc, startImgFeatNDX, 'mean', mean);
end

if isfield(X, 'Te')
  newX.Te = updatedata(X.Te, pc, startImgFeatNDX, 'mean', mean);
end

end
  
function [sortedEigVec, sortedEigVal] = getprincomp(eigVec, eigVal, k)
%% GETPRINCOMP get k principal components
% 
[sortedEigVal, eigNDX] = sort(diag(eigVal), 'descend');
sortedEigVec = eigVec(:, eigNDX(1 : k));
sortedEigVal = sortedEigVal(1 : k);
end

function rawImgFeature = rawimgfeature(data, startImgFetNDX)
mat = cell2mat(data);
rawImgFeature = mat(startImgFetNDX : end, :);
end

function [normalized, meanFeature] = normalizefeature(data, startHandFetNDX)
% Subtracts the mean from the features.
rawFeature = rawimgfeature(data, startHandFetNDX);
nframe = size(rawFeature, 2);
meanFeature = mean(rawFeature, 2);
meanFeatureRep = repmat(meanFeature, 1, nframe);
normalized = rawFeature - meanFeatureRep;
end

function data = updatedata(data, eigHand, startHandFetNDX, varargin)
narg = length(varargin);
for i = 1 : 2 : narg
  switch varargin{i}
    case 'mean' 
      rawImgFeature = rawimgfeature(data, startHandFetNDX);
      nframe = size(rawImgFeature, 2);
      meanFeature = varargin{i + 1};
      meanFeatureRep = repmat(meanFeature, 1, nframe);
      normImgFeature = rawImgFeature - meanFeatureRep;
    case 'normalized', normImgFeature = varargin{i + 1};
    otherwise, error(['invalid argument name ' varargin{i}]);
  end
end
handFeature = eigHand' * normImgFeature; % neigHand x nframe
nseq = length(data);
startNDX = 1;
for i = 1 : nseq
  old = data{i};
  endNDX = startNDX + size(old, 2) - 1;
  data{i} = [old(1 : startHandFetNDX - 1, :); handFeature(:, startNDX : endNDX)];
  startNDX = endNDX + 1;
end
end