function [gt, vocabSize] = readgt(filename, endNDX, gestureDefDir)
%% READGTCHAIRGEST reads ground truth from the data set.
%
% ARGS
% startNDX  - feature start index
% endNDX  - feature end index
%
% Return
% - gt: n x 3 matrix. The first column is the stroke id. The second
%     column is the start frame id of the stroke and the third column is
%     end frame id of the stroke.

[allLabel, gestureDict] = gesturelabel(gestureDefDir);
vocabSize = length(allLabel) - 2;

data = importdata(filename);
frameIndices = data.data;
label = data.textdata;
nevent = size(frameIndices, 1);

gt = ones(nevent, 3);

for i = 1 : nevent
  strokeLabel = label{i, 1};
  frameNDX = frameIndices(i, 1);
  
  if i < nevent
    nextEventFrameNDX = frameIndices(i + 1, 1);
  else
    nextEventFrameNDX = endNDX + 1;
  end
  
  switch strokeLabel
    case 'StartPreStroke'
      gestureLabel = 'PreStroke';
    case 'StartGesture'
      gestureLabel = label{i, 2};
    case 'StopGesture'
      gestureLabel = 'PostStroke';
      frameNDX = frameNDX + 1;
      nextEventFrameNDX = nextEventFrameNDX + 1;
    case 'StopPostStroke'
      gestureLabel = 'Rest';
      frameNDX = frameNDX + 1;
  end
  
  gestureNDX = gestureDict(gestureLabel);
  gt(i, 1 : 3) = [gestureNDX frameNDX nextEventFrameNDX - 1];
end

end