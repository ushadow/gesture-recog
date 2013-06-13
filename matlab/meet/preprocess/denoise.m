function X = denoise(X, param)
% DENOISE removes the black holes due to aliasing.
%
% ARGS
% data  - the feature data or a structure of feature data.
% - param: hyperparameters. It should have the field startHandFetNDX.
%
% Return:
% - R: the result has the same structure as the input data.
se = strel('square', 3);
if isstruct(X)
  fn = fieldnames(X);
  for i = 1 : length(fn)
    D = X.(fn{i});
    denoised = denoiseone(D, param.startImgFeatNDX, se);
    X.(fn{i}) = denoised;
  end
else
  X = denoiseone(X, param.startImgFeatNDX, se);
end
end

function data = denoiseone(data, startImgFeatNDX, se)
% ARGS
% data  - a cell array of feature sequences. Each sequence is a matrix.

nseq = length(data);
for i = 1 : nseq
  seq = data{i};
  for j = 1 : size(seq, 2)
    image = seq(startImgFeatNDX : end, j);
    imageWidth = sqrt(length(image));
    image = reshape(image, imageWidth, imageWidth);
    image = imclose(image, se);
    %image = medfilt2(image, [3 3]);
    seq(startImgFeatNDX : end, j) = image(:);
  end
  data{i} = seq;
end  
end
