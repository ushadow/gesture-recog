function model = trainsegment(Y, X, restNDX)
% ARGS
% Y, X  - training data.

[rest, gesture] = separaterest(Y, X, restNDX);

model.restMean = mean(rest, 2);
model.restStd = std(rest, 0, 2);
model.gestureMean = mean(gesture, 2);
model.gestureStd = std(gesture, 0, 2);