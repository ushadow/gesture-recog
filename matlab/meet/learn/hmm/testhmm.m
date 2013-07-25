function [pred, prob, path] = testhmm(~, X, hmm, param)

nclass =  param.vocabularySize;
hmm = hmm.model;

seg = testsegment(X.Tr, hmm.segment); 
[pred.Tr, prob.Tr, path.Tr] = inference(X.Tr, seg, hmm, nclass);

seg = testsegment(X.Va, hmm.segment);
[pred.Va, prob.Va, path.Va] = inference(X.Va, seg, hmm, nclass);
end

function [pred, prob, path] = inference(X, seg, hmm, nclass)
nseqs = length(X);
pred = cell(1, nseqs);
prob = cell(1, nseqs);
path = cell(1, nseqs);
for i = 1 : nseqs;
  ev = X{i};
  pred1 = ones(1, size(ev, 2)) * nclass;
  path1 = ones(1, size(ev, 2)) * nclass;
  runs = contiguous(seg{i}, 0);
  runs = runs{1, 2};
  nruns = size(runs, 1);
  prob1 = cell(1, nruns);
  for r = 1 : nruns
    startNDX = runs(r, 1);
    endNDX = runs(r, 2);
    ll = ones(1, nclass - 1) * -inf;
    obslik = cell(1, nclass - 1);
    for c = 1 : length(ll)
      if ~isempty(hmm.prior{c})
        [ll(c), ~, obslik{c}] = mhmm_logprob(ev(:, startNDX : endNDX), ...
            hmm.prior{c}, hmm.transmat{c}, hmm.mu{c}, hmm.Sigma{c}, ...
            hmm.mixmat{c});
      end
    end
    [~, mlPred] = max(ll);
    pred1(startNDX : endNDX) = mlPred;
    [realStart, realEnd, path1(startNDX : endNDX)] = ...
        realstartend2(obslik{mlPred}, hmm, mlPred);
    pred1(startNDX : startNDX + realStart - 2) = 11;
    pred1(startNDX + realEnd : endNDX) = 12;
    prob1{r} = ll;
  end
  pred{i} = pred1;
  prob{i} = prob1;
  path{i} = path1;
end
end

function [realStart, realEnd, path] = realstartend(obslik, hmm, c)
  path = viterbi_path(hmm.prior{c}, hmm.transmat{c}, obslik);
  [~, startState] = max(hmm.prior{c});
  [~, endState] = max(hmm.term{c});
  realStart = 1;
  realEnd = length(path);
  
  startNDX = find(path ~= startState);
  if ~isempty(startNDX)
    realStart = startNDX(1);
  end
  
  endNDX = find(path ~= endState);
  if ~isempty(endNDX)
    realEnd= endNDX(end);
  end
end

function [realStart, realEnd, path] = realstartend2(obslik, hmm, c)
  path = viterbi_path(hmm.prior{c}, hmm.transmat{c}, obslik);
  realStart = 1;
  realEnd = 0;
  startNDX = find(path ~= path(1));
  if ~isempty(startNDX)
    realStart = startNDX(1);
  end
  
  endNDX = find(path ~= path(end));
  if ~isempty(endNDX)
    realEnd= endNDX(end);
  end
end