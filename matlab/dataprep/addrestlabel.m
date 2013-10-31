function [Y, X] = addrestlabel(Y, X)

[~, gestureDict] = gesturelabel();
restLabel = gestureDict('Rest');

v = X(4 : 6, :);
speed = sqrt(sum(v .* v));

y = X(2, :);

rest = speed < 0.005 & y < -0.55;
runs = contiguous(rest, 1);
runs = runs{1, 2};

for i = 1 : size(runs, 1)
  Y(1, runs(i, 1) : runs(i, 2)) = restLabel;
end

end