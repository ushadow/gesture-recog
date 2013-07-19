function [gt, vocabSize] = readgtchairgest(filename)
% READKINECTGT reads kinect ground truth data.
%
% Return
% - gt: n x 3 matrix.

[allLabel, gestureDict] = gesturelabel();
vocabSize = length(allLabel);

data = importdata(filename);
frameIndices = data.data;
label = data.textdata;
nevent = size(frameIndices, 1);

startNDX = frameIndices(1, 1);
gt = zeros(frameIndices(end, 1) - startNDX + 1, 3);

for i = 1 : nevent
  strokeLabel = label{i, 1};
  frameNDX = frameIndices(i, 1);
  nextFrameNDX = frameNDX;
  
  if i < nevent
    nextFrameNDX = frameIndices(i + 1, 1);
  end
  
  switch strokeLabel
    case 'StartPreStroke'
      gestureLabel = 'PreStroke';
    case 'StartGesture'
      gestureLabel = label{i, 2};
      nextFrameNDX = nextFrameNDX + 1;
    case 'StopGesture'
      gestureLabel = 'PostStroke';
      frameNDX = frameNDX + 1;
      nextFrameNDX = nextFrameNDX + 1;
    case 'StopPostStroke'
      gestureLabel = 'Rest';
      frameNDX = frameNDX + 1;
  end
  
  while frameNDX < nextFrameNDX
    gestureNDX = gestureDict(gestureLabel);
    gt(frameNDX - startNDX + 1, :) = [frameNDX, gestureNDX, 1];
    frameNDX = frameNDX + 1;
  end
end

end