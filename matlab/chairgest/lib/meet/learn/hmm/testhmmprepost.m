function [pred, prob, path] = testhmmprepost(Y, X, hmm, param)
%% TESTHMM tests HMM model

nclass =  param.vocabularySize;
hmm = hmm.model;

isDiag = 0;
if param.mce
  XByClass = segmentbyclassprepost(Y.Tr, X.Tr, nclass - 3);
  [hmm.prior, hmm.transmat, hmm.term, hmm.mu, hmm.Sigma, ...
      hmm.mixmat] = mhmm_mce_gd(XByClass, hmm.prior, hmm.transmat, ...
      hmm.term, hmm.mu, hmm.Sigma, hmm.mixmat);
end

restNDX = nclass;
for i = 1 : nclass - 3
  [gPrior, gTransmat, gTerm, gMu, gSigma, gMixmat] = combinehmmparam( ...
      hmm.prior(i, :), hmm.transmat(i, :), hmm.term(i, :), hmm.mu(i, :), ...
      hmm.Sigma(i, :), hmm.mixmat(i, :));
  [hmm.prior{i, 1}, hmm.transmat{i, 1}, hmm.term{i, 1}, hmm.mu{i, 1}, ...
      hmm.Sigma{i, 1}, hmm.mixmat{i, 1}] = combinerestmodel(gPrior, gTransmat, ...
      gTerm, hmm.transmat{restNDX, 1}, hmm.term{restNDX, 1}, param.nSMap, ...
      gMu, hmm.mu{restNDX, 1}, gSigma, gMixmat, hmm.Sigma{restNDX, 1}, ...
      hmm.mixmat{restNDX, 1});
end

if isfield(X, 'Tr')
  seg = testsegment(X.Tr, hmm.segment, param.subsampleFactor); 
  [pred.Tr, prob.Tr, path.Tr] = inference(X.Tr, seg, hmm, nclass, ...
                                          param.nSMap, isDiag);
end

if isfield(X, 'Va')
  seg = testsegment(X.Va, hmm.segment, param.subsampleFactor);
  [pred.Va, prob.Va, path.Va] = inference(X.Va, seg, hmm, nclass, ...
                                          param.nSMap, isDiag);
end
end

function [pred, prob, path] = inference(X, seg, hmm, nclass, nSMap, isDiag)
%%
% ARGS
% nclass  - total number of classes including pre-stroke, post-stroke and 
%           rest.
% isDiag  - true if covariance matrix is diagonal. 

nseqs = length(X);
ngestures = nclass - 3;
rest = nclass;

pred = cell(1, nseqs);
prob = cell(1, nseqs);
path = cell(1, nseqs);

for i = 1 : nseqs;
  ev = X{i};
  pred1 = ones(1, size(ev, 2)) * nclass;
  path1 = ones(1, size(ev, 2)) * (sum(cell2num(values(nSMap))) + 1);
  runs = contiguous(seg{i}, 0);
  runs = runs{1, 2};
  nruns = size(runs, 1);
  prob1 = cell(1, nruns);
  for r = 1 : nruns
    startNDX = runs(r, 1);
    endNDX = runs(r, 2);
    ll = ones(1, ngestures) * -inf;
    obslik = cell(1, ngestures);
    for c = 1 : length(ll)
      if ~isempty(hmm.prior{c})       
        [ll(c), ~, obslik{c}] = mhmm_logprob(ev(:, startNDX : endNDX), ...
            hmm.prior{c}, hmm.transmat{c}, hmm.mu{c}, hmm.Sigma{c}, ...
            hmm.mixmat{c}, hmm.term{c}, isDiag);
      end
    end
    [~, mlPred] = max(ll);
    pred1(startNDX : endNDX) = mlPred;
    [realStart, realEnd, path1(startNDX : endNDX)] = ...
        realstartend(obslik{mlPred}, hmm, mlPred, nSMap);
    if realStart == -1
      pred1(startNDX : endNDX) = rest;
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

function [realStart, realEnd, path] = realstartend(obslik, hmm, ...
    gesture, nSMap)
%% REALSTRATEND detects the actual start and end of the gesture nucleus.
%
% ARGS
% obslik  - a vector of observation likelihood for gesture c.
% hmm     - a struct of HMM parameters for all gestures.
% gesture - predicted gesture.
%
% RETURNS
% realStart   - index of actual gesture start frame relative to the
%               beginning of a segment.

  path = viterbi_path(hmm.prior{gesture}, hmm.transmat{gesture}, ...
                      obslik, hmm.term{gesture});
  [realStart, realEnd] = realstartendinpath(path, nSMap);
end

