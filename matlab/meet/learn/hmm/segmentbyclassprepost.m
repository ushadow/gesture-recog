function dataByClass = segmentbyclassprepost(Y, X, nGestures)
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
dataByClass = cell(nGestures, nstages);
for i = 1 : nseqs
  seqY = Y{i};
  seqX = X{i};
  phaseChangeNdx = find(seqY(2, :) == 2);
  startNdx = 1;
  for j = 1 : length(phaseChangeNdx)
    endNdx = phaseChangeNdx(j);
    Ylabel = seqY(1, endNdx);
    switch Ylabel
      case 11
        gestureLabel = seqY(1, endNdx + 1);
        stage = PRE;
      case 12 
        if j > 1
          gestureLabel = seqY(1, phaseChangeNdx(j - 1));
          stage = POST;
        else
          stage = REST;
        end
      case 13
        stage = REST;
      otherwise
        gestureLabel = seqY(1, endNdx);
        stage = GESTURE;
    end
    if stage < REST && gestureLabel <= nGestures
      dataByClass{gestureLabel, stage}{end + 1} = seqX(:, startNdx : endNdx);
    end
    startNdx = endNdx + 1;
  end
end
end