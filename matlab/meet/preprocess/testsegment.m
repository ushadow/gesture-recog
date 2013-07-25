function seg = testsegment(X, model)
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
  d = size(model.restMean, 1);
  x = x(1 : d, :);
  restProb = gaussian_prob(x, model.restMean, diag(model.restStd), 0, 1);
  gestureProb = gaussian_prob(x, model.gestureMean, ...
    diag(model.gestureStd), 0, 1);
  isRest = restProb > gestureProb;
  isRest = isRest';
end

function seg = removeshortseg(seg)
label = [1 0];
for i = 1 : length(label)
  runs = contiguous(seg, label(i));
  run1 = runs{1, 2};
  for r = 1 : size(run1, 1)
    startNDX = run1(r, 1);
    endNDX = run1(r, 2);
    if endNDX - startNDX < 10
      seg(startNDX : endNDX) = 1 - label(i);
    end
  end
end
end