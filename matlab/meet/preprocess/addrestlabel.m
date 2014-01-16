function Y = addrestlabel(Y, X, ~, param)
%% ADDRESTLABEL Add rest label according to speed.

sampleRate = param.kinectSampleRate;
restLabel = param.vocabularySize;
[~, ~, gestureType] = gesturelabel();
if isstruct(X)
  fn = fieldnames(X);
  for i = 1 : length(fn)
    X1 = X.(fn{i});
    Y1 = Y.(fn{i});
    Y1 = addrestlabel1(Y1, X1, sampleRate, restLabel, gestureType);
    Y.(fn{i}) = Y1;
  end
else
  Y = addrestLabel(Y, X, sampleRate, restLabel, gestureType);
end
end

function Y = addrestlabel1(Y, X, sampleRate, restLabel, gestureType)
% ARGS
% Y   - 2 x n array.
% sampleRate  - Kinect sample rate.

WSIZE = 15;
pos = X(1 : 3, :);
pos = smoothts(pos, round(WSIZE / sampleRate));
speed = computespeed(pos);

y = X(2, :);

type = gestureType(Y(1, :));
rest = speed < 0.005 & y < -0.55 & type == 0;
if any(rest)
  runs = contiguous(rest, 1);
  runs = runs{1, 2};

  for i = 1 : size(runs, 1)
    Y(1, runs(i, 1) : runs(i, 2)) = restLabel;
  end
  Y = addflabel(Y);
end
end