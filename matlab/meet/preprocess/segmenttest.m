function [stat, R, Ytrue] = segmenttest(data, model, restNDX)

Y = data.Y;
X = data.X;
split = data.split;

nseqs = size(X, 2);
allSeg = cell(1, nseqs);
for i = 1 : nseqs
  seqX = X{i};
  seqY = Y{i};
  nframes = size(seqX, 2);
  trueSeg = zeros(1, nframes);
  trueSeg(seqY(1, :) == restNDX) = 1;
  allSeg{i} = isrest(seqX, model);
  Y{i} = trueSeg;
end

Ytrue.Tr = Y(split{1});
Ytrue.Va = Y(split{2});
R.Tr = allSeg(split{1});
R.Va = allSeg(split{2});

stat = evalclassification(Ytrue, R, 'Error', @errorperframe);
end

function isRest = isrest(x, model)
  d = size(model.restMean, 1);
  x = x(1 : d, :);
  restProb = gaussian_prob(x, model.restMean, diag(model.restStd), 0, 1);
  gestureProb = gaussian_prob(x, model.gestureMean, ...
    diag(model.gestureStd), 0, 1);
  isRest = restProb > gestureProb;
  isRest = isRest';
end

