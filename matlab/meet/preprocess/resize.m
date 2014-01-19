function [X, resizeWidth] = resize(~, X, ~, param)
%% RESIZE resizes the image features.

origImgWidth = param.imageWidth;
resizeWidth = param.resizeWidth;
startImgNdx = param.startDescriptorNdx;

if isstruct(X)
  fn = fieldnames(X);
  for i = 1 : length(fn)
    D = X.(fn{i});
    X.(fn{i}) = resizeone(D, startImgNdx, origImgWidth, resizeWidth);
  end
else
  X = resizeone(X, startImgNdx, origImgWidth, resizeWidth);
end

end

function X = resizeone(X, startImgNdx, origImgWidth, newWidth)
% ARGS
% startNdx  - start of image index.

origImgLen = origImgWidth * origImgWidth;
newImgLen = newWidth * newWidth;

for i = 1 : length(X)
  seq = X{i};
  [featureLen, seqLen] = size(seq);
  nChannels = (featureLen - startImgNdx + 1) / origImgLen;
  newFeatureLen = startImgNdx - 1 + newImgLen * nChannels;
  newSeq = zeros(newFeatureLen, seqLen);
  for j = 1 : seqLen
    v = seq(:, j);
    newSeq(1 : startImgNdx - 1, j) = v(1 : startImgNdx - 1);
    startNdx = startImgNdx;
    newStartNdx = startNdx;
    for c = 1 : nChannels
      endNdx = startNdx + origImgLen - 1;
      newEndNdx = newStartNdx + newImgLen - 1;
      img = reshape(v(startNdx : endNdx), origImgWidth, origImgWidth); 
      img = imresize(img, [newWidth newWidth]);
      newSeq(newStartNdx : newEndNdx, j) = reshape(img, [], 1);
      startNdx = endNdx + 1;
      newStartNdx = newEndNdx + 1;
    end
  end
  X{i} = newSeq;
end
end