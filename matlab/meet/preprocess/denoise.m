function [X, se] = denoise(~, X, ~, param)
% DENOISE removes the black holes due to aliasing.
%
% ARGS
% X     - cell array of feature data or a structure of feature data.
% param - hyperparameters. It should have the field startHandFetNDX.
%
% RETURN
% X     - the denoised result has the same structure as the input data.

filterWinSize = param.filterWinSize;

if isfield(param, 'denoiseMethod')
  methodName = param.denoiseMethod;
else
  methodName = 'close';
end

switch methodName
  case 'med'
    method = {@medfilt2};
    se = [filterWinSize filterWinSize];
  case 'close'
    method = {@imclose @imopen};
    se = strel('square', filterWinSize);
  case 'scale'
    method = {@imresize};
    se = [16 16];
  otherwise
    error('Unknown denoise method.');
end

startDescriptorNdx = param.startDescriptorNdx;

if isstruct(X)
  fn = fieldnames(X);
  for i = 1 : length(fn)
    D = X.(fn{i});
    denoised = denoiseone(D, startDescriptorNdx, param.channels, param.imageWidth, ...
                          method, se);
    X.(fn{i}) = denoised;
  end
else
  X = denoiseone(X, startDescriptorNdx, param.channels, param.imageWidth, method, se);
end
end

function data = denoiseone(data, startDescriptorNdx, channels, ...
                           imageWidth, method, se)
% ARGS
% data  - a cell array of feature sequences or just one sequence. 
%         Each sequence is a matrix.
% descriptorRange   - (startNdx, endNdx), the start and end indices of the
%     descriptor.

if iscell(data)
  nseq = length(data);
  for i = 1 : nseq
    seq = data{i};   
    data{i} = denoiseoneseq(seq, startDescriptorNdx, channels, ...
                            imageWidth, method, se);
  end  
else
  data = denoiseoneseq(data, startDescriptorNdx, channels, imageWidth, ...
                       method, se);
end
end

function seq = denoiseoneseq(seq, startDescriptorNdx, channels, ...
                             imageWidth, method, se)
for j = 1 : size(seq, 2)
  pixelLen = imageWidth * imageWidth;
  for c = channels
    startNdx = startDescriptorNdx + pixelLen * (c - 1);
    endNdx = startNdx + pixelLen - 1;
    image = seq(startNdx : endNdx, j);
    image = reshape(image, imageWidth, imageWidth);
    for i = 1 : numel(method)
      image = method{i}(image, se);
    end
    seq(startNdx : endNdx, j) = image(:);
  end
end
end