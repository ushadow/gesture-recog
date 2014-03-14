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

nClass = param.vocabularySize;

if param.combineprepost
  % Combines the pre- and post-stroke labels into the gesture label.
  Y = combineprepost(Y);
end

nseqs = size(Y, 2);
dataByClass = cell(nClass, param.nHmmMixture);
prePostMargin = param.prePostMargin;
for i = 1 : nseqs
  seqY = Y{i};
  seqX = X{i};
  ndx = find(seqY(2, :) == 2);
  startNdx = 1;
  for j = 1 : length(ndx)
    endNdx = ndx(j);
    class = seqY(1, endNdx);
    if class <= nClass
      % Removes the start and end parts because they are pre- and
      % post-strokes.
      if strcmp(param.gestureType(class), 'S') && class < nClass
        startNdx = min(endNdx, startNdx + prePostMargin);
        endNdx = max(startNdx, endNdx - prePostMargin);
      end
      dataByClass{class, 1}{end + 1} = seqX(:, startNdx : endNdx);     
    end
    startNdx = endNdx + 1;
  end
end

if param.nHmmMixture > 1
  for i = 1 : size(dataByClass, 1)
    if strcmp(param.gestureType(i), 'D')
      data = dataByClass{i, 1};
      dist = distdtw(data);
      clusters = agglomerativeclusterseq(dist, param.nHmmMixture, ...
                                         'average');
      for j = 1 : length(clusters)
        dataByClass{i, j} = data(clusters{j});
      end
    end
  end
end
end