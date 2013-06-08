function databyclass = segmentbyclass(Y, X, nclass)
%
% ARGS
% Y   - cell array of labels. Each cell is a sequence for one recording.
% X   - cell array of observations.

nseq = size(Y, 2);
databyclass = cell(1, nclass);
for i = 1 : nseq
  seqY = Y{i};
  seqX = X{i};
  ndx = find(seqY(2, :) == 2);
  startNDX = 1;
  for j = 1 : length(ndx)
    endNDX = ndx(j);
    databyclass{seqY(1, endNDX)}{end + 1} = seqX(:, startNDX : endNDX);
    startNDX = endNDX + 1;
  end
end
end