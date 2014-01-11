function [X, resizeWidth] = resize(~, X, param)
%% RESIZE resizes the image features.

if isfield(X, 'Tr')
  X1 = X.Tr;
else
  X1 = X;
end

origImgWidth = param.imageWidth;
resizeWidth = param.resizeWidth;
startImgNdx = param.startDescriptorNdx;
X1 = resizeone(X1, startImgNdx, origImgWidth, resizeWidth);

if isfield(X, 'Tr')
  X.Tr = X1;
else
  X = X1;
end

if isfield(X, 'Va')
  X.Va = resizeone(X.Va, startImgNdx, origImgWidth, resizeWidth);
end

if isfield(X, 'Te')
  X.Te = resizeone(X.Va, startImgNdx, origImgWidth, resizeWidth);
end

end

function X = resizeone(X, startNdx, origImgWidth, newWidth)
newD = startNdx - 1 + newWidth * newWidth;
for i = 1 : length(X)
  seq = X{i};
  seqLen = size(seq, 2);
  newSeq = zeros(newD, seqLen);
  for j = 1 : seqLen
    v = seq(:, j);
    endNdx = startNdx + origImgWidth * origImgWidth - 1;
    img = reshape(v(startNdx : endNdx), origImgWidth, origImgWidth); 
    img = imresize(img, [newWidth newWidth]);
    newSeq(:, j) = [v(1 : startNdx - 1); reshape(img, [], 1)];
  end
  X{i} = newSeq;
end
end