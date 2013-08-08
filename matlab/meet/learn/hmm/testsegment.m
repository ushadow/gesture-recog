function seg = testsegment(X, model)
%% TESTSEGMENT test the segmentation of rest position from gestures.
%
% ARGS
% X  - cell arrays
%
% RETURNS
% seg - cell array of sequences. Each sequence contains 0 or 1. 1 means
% rest position.

nseqs = size(X, 2);
seg = cell(1, nseqs);
for i = 1 : nseqs
  seqX = X{i};
  seg1 = findrest(seqX, model);
  seg{i} = removeshortseg(seg1);
end
end

function isRest = findrest(x, model)
  d = size(model.restMu, 1);
  x = x(1 : d, :);
  if size(model.restMu, 3) == 1
    restProb = gaussian_prob(x, model.restMu, model.restSigma, 0, 1);
  else
    restProb = mixgauss_prob(x, model.restMu, model.restSigma, ...
                             model.restMixmat, 0, 1);
  end
  % A column vector
  gestureProb = gaussian_prob(x, model.gestureMu, model.gestureSigma, 0, 1);
  isRest = restProb(:) > gestureProb(:);
  isRest = isRest';
end

function seg = removeshortseg(seg)
% ARGS
% seg   - segment of rest and gestures. 1 is rest, 0 is gesture.

label = [1 0];
minLength = [10 10];
for i = 1 : length(label)
  runs = contiguous(seg, label(i));
  run1 = runs{1, 2};
  for r = 1 : size(run1, 1)
    startNDX = run1(r, 1);
    endNDX = run1(r, 2);
    if endNDX - startNDX < minLength(i);
      seg(startNDX : endNDX) = 1 - label(i);
    end
  end
end
end