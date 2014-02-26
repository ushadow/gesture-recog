function dataByClass = segmentbyclass(Y, X, param)
%% SEGMENTBYCLASS segments the sequences according to class labels.
%
% ARGS
% Y   - cell array of labels. Each cell is a sequence for one recording.
% X   - cell array of observations.
% nclass - number of gesture classes, including rest.
%
% RETURNS
% dataByClass - cell array of cell arrays. One cell array for each gesture
%   label. In each cell array, there are gesture sequences.

nClasses = param.vocabularySize;

if param.combineprepost
  Y = combineprepost(Y);
end

nseqs = size(Y, 2);
dataByClass = cell(1, nClasses);
for i = 1 : nseqs
  seqY = Y{i};
  seqX = X{i};
  ndx = find(seqY(2, :) == 2);
  startNdx = 1;
  for j = 1 : length(ndx)
    endNdx = ndx(j);
    class = seqY(1, endNdx);
     if class <= nClasses
      if strcmp(param.gestureType(class), 'S') && class < nClasses
        startNdx = min(endNdx, startNdx + 15);
        endNdx = max(startNdx, endNdx - 15);
      end
      dataByClass{class}{end + 1} = seqX(:, startNdx : endNdx);     
    end
    startNdx = endNdx + 1;
  end
end
end