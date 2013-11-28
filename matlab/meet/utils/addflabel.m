function Y = addflabel(Y)
%% ADDFLABEL adds the F variable label that indicates when the gesture
% stops when F == 2.
%
% ARGS
% Y   - cell array of Y data

if iscell(Y)
  for i = 1 : numel(Y)
    seq = Y{i};  
    Y{i} = addflabelone(seq);
  end
else
  Y = addflabelone(Y);
end
end

function Y = addflabelone(Y)
shifted = [Y(1, 2 : end) Y(1, end)];
Y(2, :) = 1;
Y(2, (Y(1, :) - shifted) ~= 0) = 2;
Y(2, end) = 2;
end