function model = trainsegment(Y, X, restNDX)
% ARGS
% Y, X  - training data.

nseqs = size(Y, 2);
rest = cell(1, nseqs);
gesture = cell(1, nseqs);
for i = 1 : nseqs
  seqY = Y{i};
  seqX = X{i};
  ndx = seqY(1, :) == restNDX;
  rest{i} = seqX(:, ndx);
  gesture{i} = seqX(:, ~ndx);
end

rest = cell2mat(rest);
gesture = cell2mat(gesture);

model.restMean = mean(rest, 2);
model.restStd = std(rest, 0, 2);
model.gestureMean = mean(gesture, 2);
model.gestureStd = std(gesture, 0, 2);