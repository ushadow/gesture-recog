function [X, model] = hogfeature(~, X, param)
%
% ARGS
% X   - Feature structure or cell array.
% - param: structure with fields:
%   - startHandFetNDX
%   - imageSize
%   - sBin
%   - oBin

startImgFeatNDX = param.startDescriptorNdx;
imageWidth = param.imageWidth;
model = [];

if isfield(X, 'Tr')
  X.Tr = hogdesc(X.Tr, startImgFeatNDX, imageWidth, param);
else
  X = hogdesc(X, startImgFeatNDX, imageWidth, param);
end

if isfield(X, 'Va')
  X.Va = hogdesc(X.Va, startImgFeatNDX, imageWidth, param);
end

if isfield(X, 'Te')
  X.Te = hogdesc(X.Te, startImgFeatNDX, imageWidth, param);
end

end

function X = hogdesc(X, startHandFetNDX, imageWidth, param)
%
% ARGS
% data  - cell array of sequences.

sBin = param.sBin;
oBin = param.oBin;

newWidth = floor(imageWidth / sBin) - 2;
newFeatureSize = newWidth * newWidth * oBin;

for i = 1 : numel(X)
  seq = X{i};
  nframe = size(seq, 2);
  newSeq = zeros(newFeatureSize + startHandFetNDX - 1, nframe);
  for j = 1 : nframe
    I = reshape(seq(startHandFetNDX : end, j), imageWidth, imageWidth);
    hogFeature = hog(double(I), sBin, oBin);
    o = size(hogFeature, 3);
    hogFeature = hogFeature(:, :, 1 : o / 4); % Only use one normalization.
    newSeq(:, j)= [seq(1 : startHandFetNDX - 1, j); ... 
              reshape(hogFeature, numel(hogFeature), 1)];
  end
  X{i} = newSeq;
end
end
