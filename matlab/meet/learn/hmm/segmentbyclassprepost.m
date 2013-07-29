function dataByClass = segmentbyclassprepost(Y, X, ngestures)
% ARGS
% ngestures  - number of gestures, ignore pre- and post-strokes and rest.
%
% RETURNS
% dataByClass   - ngestures x nstages cell array of feature sequences.

PRE = 1;
GESTURE = 2;
POST = 3;
REST = 4;

nseqs = size(Y, 2);
nstages = 3;
dataByClass = cell(ngestures, nstages);
for i = 1 : nseqs
  seqY = Y{i};
  seqX = X{i};
  ndx = find(seqY(2, :) == 2);
  startNDX = 1;
  for j = 1 : length(ndx)
    endNDX = ndx(j);
    Ylabel = seqY(1, endNDX);
    switch Ylabel
      case 11
        gestureLabel = seqY(1, endNDX + 1);
        stage = PRE;
      case 12 
        gestureLabel = seqY(1, ndx(j - 1));
        stage = POST;
      case 13
        stage = REST;
      otherwise
        gestureLabel = seqY(1, endNDX);
        stage = GESTURE;
    end
    if stage < REST
      dataByClass{gestureLabel, stage}{end + 1} = seqX(:, startNDX : endNDX);
    end
    startNDX = endNDX + 1;
  end
end
end