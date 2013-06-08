function R = denoisebyclose(data, param)
% DENOISE removes the black holes due to aliasing.
%
% Args:
% - data: the feature data (X) or a structure of feature data.
% - param: hyperparameters. It should have the field startHandFetNDX.
%
% Return:
% - R: the result has the same structure as the input data.
se = strel('square', 3);
if isstruct(data)
  fn = fieldnames(data);
  for i = 1 : length(fn)
    D = data.(fn{i});
    denoised = denoiseone(D, param.startHandFetNDX, se);
    data.(fn{i}) = denoised;
  end
  R = data;
else
  R = denoiseone(data, param.startHandFetNDX, se);
end
end

function data = denoiseone(data, startHandFetNDX, se)
% Args:
% - data: a cell array of feature sequences. Each sequence is a cell array.

nseq = length(data);
for i = 1 : nseq
  seq = data{i};
  for j = 1 : length(seq)
    hand = seq{j}(startHandFetNDX : end);
    imageWidth = sqrt(length(hand));
    hand = reshape(hand, imageWidth, imageWidth)';
    closed = imclose(hand, se)';
    seq{j}(startHandFetNDX : end) = closed(:);
  end
  data{i} = seq;
end  
end
