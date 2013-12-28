function [X, se] = denoise(X, param, methodName)
% DENOISE removes the black holes due to aliasing.
%
% ARGS
% X     - the feature data or a structure of feature data.
% param - hyperparameters. It should have the field startHandFetNDX.
%
% RETURN
% X     - the denoised result has the same structure as the input data.

FILTER_WIN_SIZE = 3;

if nargin <= 2
  if isfield(param, 'denoiseMethod')
    methodName = param.denoiseMethod;
  else
    methodName = 'close';
  end
end

switch methodName
  case 'med'
    method = {@medfilt2};
    se = [FILTER_WIN_SIZE FILTER_WIN_SIZE];
  case 'close'
    method = {@imclose, @imopen};
    se = strel('square', FILTER_WIN_SIZE);
  case 'scale'
    method = {@imresize};
    se = [16 16];
  otherwise
    error('Unknown denoise method.');
end

if isstruct(X)
  fn = fieldnames(X);
  for i = 1 : length(fn)
    D = X.(fn{i});
    denoised = denoiseone(D, param.startDescriptorNdx, method, se);
    X.(fn{i}) = denoised;
  end
else
  X = denoiseone(X, param.startDescriptorNdx, method, se);
end
end

function data = denoiseone(data, startImageNdx, method, se)
% ARGS
% data  - a cell array of feature sequences. Each sequence is a matrix.

if iscell(data)
  nseq = length(data);
  for i = 1 : nseq
    seq = data{i};   
    data{i} = denoiseoneseq(seq, startImageNdx, method, se);
  end  
else
  data = denoiseoneseq(data, startImageNdx, method, se);
end
end

function seq = denoiseoneseq(seq, startImageNdx, method, se)
for j = 1 : size(seq, 2)
  image = seq(startImageNdx : end, j);
  imageWidth = sqrt(length(image));
  image = reshape(image, imageWidth, imageWidth);
  for i = 1 : numel(method)
    image = method{i}(image, se);
  end
  seq(startImageNdx : end, j) = image(:);
end
end