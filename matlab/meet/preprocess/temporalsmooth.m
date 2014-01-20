function [X, wsize] = temporalsmooth(~, X, ~, param)

wsize = 25;
sampleRate = param.subsampleFactor;

dataType = {'Tr', 'Va', 'Te'};
for i = 1 : length(dataType)
  dt = dataType{i};
  if isfield(X, dt)
    X1 = X.(dt);
    X.(dt) = smooth1(X1, sampleRate, wsize);
  end
end
end

function X = smooth1(X, sampleRate, wsize)
% ARGS
% X - cell array of sequences.

for i = 1 : numel(X)
  seq = X{i};
  seq = smoothts(seq, 'b', round(wsize / sampleRate));
  X{i} = seq;
end
end