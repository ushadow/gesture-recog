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
nChannels = param.nChannels;
imageWidth = param.imageWidth;
model = [];

if isfield(X, 'Tr')
  X.Tr = hogdesc(X.Tr, startImgFeatNDX, nChannels, imageWidth, param);
else
  X = hogdesc(X, startImgFeatNDX, nChannels, imageWidth, param);
end

if isfield(X, 'Va')
  X.Va = hogdesc(X.Va, startImgFeatNDX, nChannels, imageWidth, param);
end

if isfield(X, 'Te')
  X.Te = hogdesc(X.Te, startImgFeatNDX, nChannels, imageWidth, param);
end

end

function X = hogdesc(X, startHandFetNdx, nChannels, imageWidth, param)
%
% ARGS
% data  - cell array of sequences.

sBin = param.sBin;
oBin = param.oBin;

newWidth = floor(imageWidth / sBin) - 2;
newFeatureSize = newWidth * newWidth * oBin * nChannels;

for i = 1 : numel(X)
  seq = X{i};
  nframe = size(seq, 2);
  newSeq = zeros(newFeatureSize + startHandFetNdx - 1, nframe);
  for j = 1 : nframe
    newSeq(1 : startHandFetNdx - 1, j)= seq(1 : startHandFetNdx - 1, j); 
    startNdx = startHandFetNdx;
    hogStart = startNdx;
    for c = 1 : nChannels
      endNdx = startNdx + imageWidth * imageWidth - 1;
      I = reshape(seq(startNdx : endNdx, j), imageWidth, imageWidth);
      hogFeature = hog(double(I), sBin, oBin);
      o = size(hogFeature, 3);
      hogFeature = hogFeature(:, :, 1 : o / 4); % Only use one normalization.
      hogLen = numel(hogFeature);
      hogEnd = hogStart + hogLen - 1;
      newSeq(hogStart : hogEnd, j)= reshape(hogFeature, hogLen, 1);
      startNdx = endNdx + 1;
      hogStart = hogEnd + 1;
    end
  end
  X{i} = newSeq;
end
end
