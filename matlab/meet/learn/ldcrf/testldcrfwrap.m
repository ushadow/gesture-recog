function [pred, prob, path] = testldcrfwrap(Y, X, model, param)

nclasses = param.vocabularySize;
dataType = {'Tr', 'Va'};
path = [];

for i = 1 : length(dataType)
  dt = dataType{i};
  if isfield(X, dt)
    seg = testsegment(X.(dt), model.segment, param.subsampleFactor);
    [pred.(dt), prob.(dt)] = inference(Y.(dt), X.(dt), seg, model, nclasses);
  end
end
end

function [pred, prob] = inference(Y, X, seg, model, nclasses)
%%
% ncalsses  - number of all possible classes, including rest.

nSeqs = length(X);
pred = cell(1, nSeqs);
prob = cell(1, nSeqs);
for i = 1 : nSeqs
  ev = X{i};
  label = Y{i}(1, :);
  pred1 = ones(1, size(ev, 2)) * nclasses;
  runs = contiguous(seg{i}, 0);
  runs = runs{1, 2};
  nRuns = size(runs, 1);
  prob1 = cell(1, nRuns);
  for r = 1 : nRuns
    startNdx = runs(r, 1);
    endNdx = runs(r, 2);
    ll = testLDCRF(model.model, {ev(:, startNdx : endNdx)}, ...
        {label(startNdx : endNdx)});
    newLabel = mostlikelilabel(ll);
    pred1(startNdx : endNdx) = filterlabel(newLabel{1});
    prob{r} = ll{1};
  end
  pred{i} = pred1;
  prob{i} = prob1;  
end
end

function label = filterlabel(label, nClasses)
nGestures = nClasses - 3;
gestureLen = zero(1, nGestures);
runs = contiguous(label);
for i = 1 : size(runs, 1)
  if runs{i, 1} <= nGestures
    run = runs{i, 2};
    gestureLen(i) = gestureLen(i) + sum(run(:, 2) - run(:, 1) + 1);
  end
end
[~, gesture] = max(gestureLen);
label(label <= nGestures) = gesture;
end
