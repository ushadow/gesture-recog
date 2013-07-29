function dataByClass = segmentbyclass(Y, X, nclass, combineprepost)
%% SEGMENTBYCLASS segments the sequences according to class labes.
%
% ARGS
% Y   - cell array of labels. Each cell is a sequence for one recording.
% X   - cell array of observations.

if combineprepost
  Y = combineprepost(Y);
end

nseqs = size(Y, 2);
dataByClass = cell(1, nclass);
for i = 1 : nseqs
  seqY = Y{i};
  seqX = X{i};
  ndx = find(seqY(2, :) == 2);
  startNDX = 1;
  for j = 1 : length(ndx)
    endNDX = ndx(j);
    dataByClass{seqY(1, endNDX)}{end + 1} = seqX(:, startNDX : endNDX);
    startNDX = endNDX + 1;
  end
end
end