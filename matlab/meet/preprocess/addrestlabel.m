function [Y, X, frame] = addrestlabel(Y, X, frame, param)
%% ADDRESTLABEL Add rest label according to speed. Only add rest label for 
%   type 0 (discrete) gestures.
%
% ARGS
% Y, X, frame - cell array of sequences or structure of cell arrays.

restLabel = param.vocabularySize;

if isstruct(X)
  fn = fieldnames(X);
  for i = 1 : length(fn)
    X1 = X.(fn{i});
    Y1 = Y.(fn{i});
    frame1 = frame.(fn{i});
    [Y.(fn{i}), X.(fn{i}), frame.(fn{i})] = addrestlabel1(Y1, X1, frame1,...
          restLabel);
  end
else
  [Y, X, frame] = addrestlabel1(Y, X, frame, restLabel);
end
end

function [Y, X, frame] = addrestlabel1(Y, X, frame, restLabel)
% ARGS
% Y   - 2 x n array.

for n = 1 : numel(X)
  X1 = X{n};
  Y1 = Y{n};
  frame1 = frame{n};
  pos = X1(1 : 3, :);
  speed = computespeed(pos, frame1);

  y = X1(2, :);

  rest = speed < 0.009 & y < -0.55;
  if any(rest)
    runs = contiguous(rest, 1);
    runs = runs{1, 2};

    for i = 1 : size(runs, 1)
      startNdx = runs(i, 1);
      endNdx = runs(i, 2);
      Y1(1, startNdx : endNdx) = restLabel;
    end   
  end
  
  Y1 = removeshort(Y1, restLabel);
  Y{n} = addflabel(Y1);
end
end

function Y1 = removeshort(Y1, restLabel)

% Each gesture is about 3s.
REMOVE_LEN = 5;

runs = contiguous(Y1(1, :));
for i = 1 : size(runs, 1)
  if runs{i, 1} ~= restLabel
    r = runs{i, 2};
    for j = 1 : size(r, 1)
      startNdx = r(j, 1);
      endNdx = r(j, 2);
      if endNdx - startNdx + 1 < REMOVE_LEN 
        Y1(1, startNdx : endNdx) = restLabel;
      end
    end
  end 
end
end