function [pred, prob, path] = testhcrfwrap(Y, X, model, param)

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
Y = combineprepost(Y);
nseqs = length(X);

pred = cell(1, nseqs);
prob = cell(1, nseqs);

for i = 1 : nseqs
  ev = X{i};
  label = Y{i}(1, :);
  pred1 = ones(1, size(ev, 2)) * nclasses;
  runs = contiguous(seg{i}, 0);
  runs = runs{1, 2};
  nruns = size(runs, 1);
  prob1 = cell(1, nruns);
  for r = 1 : nruns
    startNdx = runs(r, 1); 
    endNdx = runs(r, 2);
    ll = testHCRF(model.model, {ev(:, startNdx : endNdx)}, ...
         {label(startNdx : endNdx)});  
    newLabel = mostlikelilabel(ll);
    newLabel = newLabel{1};
    newEndNdx = startNdx + length(newLabel) - 1;
    pred1(startNdx : newEndNdx) = newLabel;
    pred1(newEndNdx + 1 : endNdx) = newLabel(end);
    prob1{r} = ll{1};
  end
  pred{i} = pred1;
  prob{i} = prob1;
end
end