function dataByClass = segmentbyclass(Y, X, nclass, combinePrepost)
%% SEGMENTBYCLASS segments the sequences according to class labels.
%
% ARGS
% Y   - cell array of labels. Each cell is a sequence for one recording.
% X   - cell array of observations.
%
% RETURNS
% dataByClass - cell array of cell arrays. One cell array for each gesture
%   label. In each cell array, there are gesture sequences.

if combinePrepost
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