function X = hogfeature(X, param)
%
% Args:
% - param: structure with fields:
%   - startHandFetNDX
%   - imageSize
%   - sBin
%   - oBin

imageWidth = param.imageWidth;
startImgFeatNDX = param.startImgFeatNDX;

if isfield(X, 'Tr')
  X.Tr = hoghand1(X.Tr, startImgFeatNDX, imageWidth, param);
else
  X = hoghand1(X, startImgFeatNDX, imageWidth, param);
end

if isfield(X, 'Va')
  X.Va = hoghand1(X.Va, startImgFeatNDX, imageWidth, param);
end

if isfield(X, 'Te')
  X.Te = hoghand1(X.Te, startImgFeatNDX, imageWidth, param);
end

end

function X = hoghand1(X, startHandFetNDX, imageWidth, param)
%
% Args:
% - data: cell array of sequences.

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
