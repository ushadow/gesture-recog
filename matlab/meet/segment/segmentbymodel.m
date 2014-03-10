function seg = segmentbymodel(X, ~, model, subsampleFactor)
%% TESTSEGMENT test the segmentation of rest position from gestures.
%
% ARGS
% X  - cell arrays
%
% RETURNS
% seg - n-by-2 matrix of start and end indices of segments.

nseqs = size(X, 2);
seg = cell(1, nseqs);
for i = 1 : nseqs
  seq1 = X{i};
  restMask = findrest(seq1, model);
  restMask = removeshortseg(restMask, subsampleFactor);
  runs = contiguous(restMask, 0);
  seg{i} = runs{1, 2};
end
end

function isRest = findrest(x, model)
%% FINDREST find rest frames using the rest model.

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

function seg = removeshortseg(seg, subsampleFactor)
%% REMOVESHORTSEG removes both rest and non-rest short segments.
%
% ARGS
% seg   - segment of rest and gestures. 1 is rest, 0 is gesture.

label = [1 0];
minLength = [50 50];
for i = 1 : length(label)
  if ~isempty(find(seg == label(i), 1))
    runs = contiguous(seg, label(i));
    run1 = runs{1, 2};
    for r = 1 : size(run1, 1)
      startNDX = run1(r, 1);
      endNDX = run1(r, 2);
      if endNDX - startNDX < minLength(i) / subsampleFactor;
        seg(startNDX : endNDX) = 1 - label(i);
      end
    end
  end
end
end