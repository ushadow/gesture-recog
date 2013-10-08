function [gt, vocabSize] = readgtchairgest(filename, startNDX, endNDX)
%% READGTCHAIRGEST reads ground truth from chairgest data set.
%
% ARGS
% startNDX  - feature start index
% endNDX  - feature end indx
%
% Return
% - gt: n x 3 matrix. The first column is frame ids. The seconde column is 
%       gesture labels.

[allLabel, gestureDict] = gesturelabel();
vocabSize = length(allLabel);

data = importdata(filename);
frameIndices = data.data;
label = data.textdata;
nevent = size(frameIndices, 1);

if nargin < 2
  startNDX = frameIndices(1, 1);
  endNDX = frameIndices(end, 1);
end

startNDX = min(startNDX, frameIndices(1, 1));
endNDX = max(endNDX, frameIndices(end, 1));
  
gt = ones(endNDX - startNDX + 1, 3);

gestureLabel = 'Rest';
gestureNDX = gestureDict(gestureLabel);
frameIds = startNDX : frameIndices(1, 1) - 1;
gt(frameIds - startNDX + 1, 1) = frameIds;
gt(frameIds - startNDX + 1, 2) = gestureNDX;

frameIds = frameIndices(end, 1) + 1 : endNDX;
gt(frameIds - startNDX + 1, 1) = frameIds;
gt(frameIds - startNDX + 1, 2) = gestureNDX;

for i = 1 : nevent
  strokeLabel = label{i, 1};
  frameNDX = frameIndices(i, 1);
  nextEventFrameNDX = frameNDX;
  
  if i < nevent
    nextEventFrameNDX = frameIndices(i + 1, 1);
  end
  
  switch strokeLabel
    case 'StartPreStroke'
      gestureLabel = 'PreStroke';
    case 'StartGesture'
      gestureLabel = label{i, 2};
      nextEventFrameNDX = nextEventFrameNDX + 1;
    case 'StopGesture'
      gestureLabel = 'PostStroke';
      frameNDX = frameNDX + 1;
      nextEventFrameNDX = nextEventFrameNDX + 1;
    case 'StopPostStroke'
      gestureLabel = 'Rest';
      frameNDX = frameNDX + 1;
  end
  
  gestureNDX = gestureDict(gestureLabel);
  frameIds = frameNDX : nextEventFrameNDX - 1;
  gt(frameIds - startNDX + 1, 1) = frameIds;
  gt(frameIds - startNDX + 1, 2) = gestureNDX;
end

end