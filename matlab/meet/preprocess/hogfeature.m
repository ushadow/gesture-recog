function [X, model] = hogfeature(~, X, ~, param)
%
% ARGS
% X   - Feature structure or cell array.
% - param: structure with fields:
%   - startHandFetNDX
%   - imageSize
%   - sBin
%   - oBin

startImgFeatNDX = param.startDescriptorNdx;
channels = param.channels;
imageWidth = param.imageWidth;
model = [];

if isfield(X, 'Tr')
  X.Tr = hogdesc(X.Tr, startImgFeatNDX, channels, imageWidth, param);
else
  X = hogdesc(X, startImgFeatNDX, channels, imageWidth, param);
end

if isfield(X, 'Va')
  X.Va = hogdesc(X.Va, startImgFeatNDX, channels, imageWidth, param);
end

if isfield(X, 'Te')
  X.Te = hogdesc(X.Te, startImgFeatNDX, channels, imageWidth, param);
end

end

function X = hogdesc(X, startHandFetNdx, channels, imageWidth, param)
%
% ARGS
% data  - cell array of sequences.

sBin = param.sBin;
oBin = param.oBin;
nFolds = param.nFolds;

newWidth = floor(imageWidth / sBin) - 2;
newFeatureSize = newWidth * newWidth * oBin * length(channels) * nFolds;

for i = 1 : numel(X)
  seq = X{i};
  nFrames = size(seq, 2);
  newSeq = zeros(newFeatureSize + startHandFetNdx - 1, nFrames);
  for j = 1 : nFrames
    newSeq(1 : startHandFetNdx - 1, j)= seq(1 : startHandFetNdx - 1, j); 
    hogStart = startHandFetNdx;
    pixelLen = imageWidth * imageWidth;
    for c = channels
      startNdx = startHandFetNdx + pixelLen * (c - 1);
      endNdx = startNdx + pixelLen - 1;
      I = reshape(seq(startNdx : endNdx, j), imageWidth, imageWidth);
      hogFeature = hog(double(I), sBin, oBin);
      o = size(hogFeature, 3);
      hogFeature = hogFeature(:, :, 1 : o * nFolds / 4);
      hogLen = numel(hogFeature);
      hogEnd = hogStart + hogLen - 1;
      newSeq(hogStart : hogEnd, j)= reshape(hogFeature, hogLen, 1);
      hogStart = hogEnd + 1;
    end
  end
  X{i} = newSeq;
end
end
