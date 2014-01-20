function Y = addrestlabel(Y, X, frame, param)
%% ADDRESTLABEL Add rest label according to speed.
%
% ARGS
% Y, X, frame - cell array of sequences or structure of cell arrays.

restLabel = param.vocabularySize;
[~, ~, gestureType] = gesturelabel();
if isstruct(X)
  fn = fieldnames(X);
  for i = 1 : length(fn)
    X1 = X.(fn{i});
    Y1 = Y.(fn{i});
    frame1 = frame.(fn{i});
    Y1 = addrestlabel1(Y1, X1, frame1, restLabel, gestureType);
    Y.(fn{i}) = Y1;
  end
else
  Y = addrestlabel1(Y, X, frame, restLabel, gestureType);
end
end

function Y = addrestlabel1(Y, X, frame, restLabel, gestureType)
% ARGS
% Y   - 2 x n array.
% sampleRate  - Kinect sample rate.

for n = 1 : numel(X)
  X1 = X{n};
  Y1 = Y{n};
  frame1 = frame{n};
  pos = X1(1 : 3, :);
  speed = computespeed(pos, frame1);

  y = X1(2, :);

  type = gestureType(Y1(1, :));
  rest = speed < 0.005 & y < -0.55 & type == 0;
  if any(rest)
    runs = contiguous(rest, 1);
    runs = runs{1, 2};

    for i = 1 : size(runs, 1)
      Y1(1, runs(i, 1) : runs(i, 2)) = restLabel;
    end
    Y{n} = addflabel(Y1);
  end
end
end