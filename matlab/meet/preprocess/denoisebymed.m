function X = denoisebymed(X, param)
% DENOISE removes the black holes due to aliasing.
%
% Args:
% - data: the feature data (X) or a structure of feature data.
% - param: hyperparameters. It should have the field startHandFetNDX.
%
% Return:
% - R: the result has the same structure as the input data.

if isstruct(X)
  fn = fieldnames(X);
  for i = 1 : length(fn)
    D = X.(fn{i});
    denoised = denoiseone(D, param.startImgFeatNDX);
    X.(fn{i}) = denoised;
  end
else
  X = denoiseone(X, param.startImgFeatNDX);
end
end

function data = denoiseone(data, startImgFeatNDX)
% ARGS
% data  - a cell array of feature sequences. Each sequence is a matrix.

FILTER_WIN_SIZE = 3;
nseq = length(data);
for i = 1 : nseq
  seq = data{i};
  for j = 1 : size(seq, 2)
    image = seq(startImgFeatNDX : end, j);
    imageWidth = sqrt(length(image));
    image = reshape(image, imageWidth, imageWidth)';
    res = medfilt2(image, [FILTER_WIN_SIZE, FILTER_WIN_SIZE])';
    seq(startImgFeatNDX : end, j) = res(:);
  end
  data{i} = seq;
end  
end