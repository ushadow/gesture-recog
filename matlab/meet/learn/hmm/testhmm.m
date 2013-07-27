function [pred, prob, path] = testhmm(~, X, hmm, param)
%% TESTHMM tests HMM model

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
    ll = ones(1, nclass - 3) * -inf;
    obslik = cell(1, nclass - 1);
    for c = 1 : length(ll)
      if ~isempty(hmm.prior{c})
        [prior, transmat, mu, Sigma, mixmat, term] = combinehmmparam(...
            hmm.prior([11 c 12]), hmm.transmat([11 c 12]), hmm.mu([11 c 12]), ...
            hmm.Sigma([11 c 12]), hmm.mixmat([11 c 12]), hmm.term([11 c 12]));
        [ll(c), ~, obslik{c}] = mhmm_logprob(ev(:, startNDX : endNDX), ...
            prior, transmat, mu, Sigma, mixmat, term);
      end
    end
    [~, mlPred] = max(ll);
    pred1(startNDX : endNDX) = mlPred;
    [realStart, realEnd, path1(startNDX : endNDX)] = ...
        realstartend2(obslik{mlPred}, hmm, mlPred);
    if realStart == -1
      pred1(startNDX : endNDX) = 13;
    else
      pred1(startNDX : startNDX + realStart - 2) = 11;
      pred1(startNDX + realEnd : endNDX) = 12;
    end
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
  [prior, transmat, ~, ~, ~, term] = combinehmmparam(...
            hmm.prior([11 c 12]), hmm.transmat([11 c 12]), hmm.mu([11 c 12]), ...
            hmm.Sigma([11 c 12]), hmm.mixmat([11 c 12]), hmm.term([11 c 12]));
  path = viterbi_path(prior, transmat, obslik, term);
  
  if computetransitions(path) <= 3
    realStart = -1;
    realEnd = -1;
    return;
  end
  
  realStart = 1;
  realEnd = 0;
  gestureNDX = find(path > 3 & path <= 10);
  if ~isempty(gestureNDX)
    realStart = gestureNDX(1);
    realEnd = gestureNDX(end);
  end
end

function n = computetransitions(path)
  runs = contiguous(path);
  n = 0;
  for i = 1 : size(runs, 1)
    n = n + size(runs{i, 2}, 1);
  end
end