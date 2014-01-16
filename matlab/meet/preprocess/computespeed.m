function speed = computespeed(X, frame)
% ARGS
% X   - position

v = zeros(size(X));
time = ones(size(frame));
v(:, 2 : end) = X(:, 2 : end) - X(:, 1 : end - 1);
time(:, 2 : end) = frame(1, 2 : end) - frame(1, 1 : end - 1);
speed = sqrt(sum(v .* v)) ./ time;
end