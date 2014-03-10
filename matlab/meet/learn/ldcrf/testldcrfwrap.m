function [pred, prob, path, seg] = testldcrfwrap(Y, X, ~, model, param)

nClasses = param.vocabularySize;
dataType = {'Tr', 'Va'};
path = [];
seg = [];

for i = 1 : length(dataType)
  dt = dataType{i};
  if isfield(X, dt)
    seg = param.testsegment(X.(dt), [], model.segment, param.subsampleFactor);
    [pred.(dt), prob.(dt)] = inference(Y.(dt), X.(dt), seg, model, nClasses);
  end
end
end

function [pred, prob] = inference(Y, X, seg, model, nClass)
%%
% ncalsses  - number of all possible classes, including rest.

nSeqs = length(X);
pred = cell(1, nSeqs);
prob = cell(1, nSeqs);
nGesture = nClass - 3;
for i = 1 : nSeqs
  ev = X{i};
  label = Y{i}(1, :);
  pred1 = ones(1, size(ev, 2)) * nClass;
  runs = seg{i};
  nRuns = size(runs, 1);
  prob1 = cell(1, nRuns);
  for r = 1 : nRuns
    startNdx = runs(r, 1);
    endNdx = runs(r, 2);
    [ll, predLabel] = test(model.model, {ev(:, startNdx : endNdx)}, ...
              {label(startNdx : endNdx)});
    predLabel = convertlabel(int32(predLabel{1}) + 1, nGesture);
    pred1(startNdx : endNdx) = predLabel;
    prob{r} = ll{1};
  end
  pred{i} = pred1;
  prob{i} = prob1;  
end
end

function label = convertlabel(label, nGesture)
I = label > nGesture & mod((label - nGesture), 2) == 1;
label(I) = nGesture + 1;
I = label > nGesture & mod((label - nGesture), 2) == 0;
label(I) = nGesture + 2;
end
