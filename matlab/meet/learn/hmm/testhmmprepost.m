function [pred, prob, path, seg] = testhmmprepost(~, X, frame, hmm, param)
%% TESTHMMPREPOST tests HMM model with pre- and post-stroke models. 

nclass =  param.vocabularySize;
hmm = hmm.model;

isDiag = 0;

% if param.mce
%   XByClass = segmentbyclassprepost(Y.Tr, X.Tr, nclass - 3);
%   [hmm.prior, hmm.transmat, hmm.term, hmm.mu, hmm.Sigma, ...
%       hmm.mixmat] = mhmm_mce_gd(XByClass, hmm.prior, hmm.transmat, ...
%       hmm.term, hmm.mu, hmm.Sigma, hmm.mixmat);
% end

restNdx = nclass;
for i = 1 : nclass - 3
  [gPrior, gTransmat, gTerm, gMu, gSigma, gMixmat] = combinehmmparam( ...
      hmm.prior(i, :), hmm.transmat(i, :), hmm.term(i, :), hmm.mu(i, :), ...
      hmm.Sigma(i, :), hmm.mixmat(i, :), param.nSMap);
  if ~isempty(param.segment)
    [hmm.prior{i, 1}, hmm.transmat{i, 1}, hmm.term{i, 1}, hmm.mu{i, 1}, ...
        hmm.Sigma{i, 1}, hmm.mixmat{i, 1}] = combinerestmodel(gPrior, gTransmat, ...
        gTerm, hmm.transmat{restNdx, 1}, hmm.term{restNdx, 1}, param.nSMap, ...
        gMu, hmm.mu{restNdx, 1}, gSigma, gMixmat, hmm.Sigma{restNdx, 1}, ...
        hmm.mixmat{restNdx, 1});
  else
    hmm.prior{i, 1} = gPrior;
    hmm.transmat{i, 1} = gTransmat;
    hmm.term{i, 1} = gTerm;
    hmm.mu{i, 1} = gMu;
    hmm.Sigma{i, 1} = gSigma;
    hmm.mixmat{i, 1} = gMixmat;
  end
end

dataTypes = {'Tr', 'Va'};
for i = 1 : length(dataTypes)
  dt = dataTypes{i};
  if isfield(X, dt)
    seg1 = param.testsegment(X.(dt), frame.(dt), hmm.segment, ...
                             param.subsampleFactor); 
    [pred.(dt), prob.(dt), path.(dt)] = inference(X.(dt), seg1, ...
        hmm, nclass, param.nSMap, isDiag);
    seg.(dt) = seg1;
  end
end
end

function [pred, prob, path] = inference(X, seg, hmm, nclass, nSMap, isDiag)
%%
% ARGS
% seg     - a cell array of matrices. Each row is [startNdx endNdx] of a segment.
% nclass  - total number of classes including pre-stroke, post-stroke and 
%           rest.
% isDiag  - true if covariance matrix is diagonal. 

nSeqs = length(X);
nGestures = nclass - 3;

pred = cell(1, nSeqs);
prob = cell(1, nSeqs);
path = cell(1, nSeqs);

for i = 1 : nSeqs;
  ev = X{i}; % one sequence
  pred1 = ones(1, size(ev, 2)) * nclass;
  path1 = ones(1, size(ev, 2)) * (sum(cell2num(values(nSMap))) + 1);
  seg1 = seg{i};
  nruns = size(seg1, 1);
  prob1 = cell(1, nruns);
  for r = 1 : nruns
    startNdx = seg1(r, 1);
    endNdx = seg1(r, 2);
    ll = ones(1, nGestures) * -inf;
    obslik = cell(1, nGestures);
    for c = 1 : length(ll)
      if ~isempty(hmm.prior{c})       
        if startNdx > size(ev, 2) || endNdx > size(ev, 2)
          error('Index out of bound. seq = %d', i);
        end
        [ll(c), ~, obslik{c}] = mhmm_logprob(ev(:, startNdx : endNdx), ...
            hmm.prior{c}, hmm.transmat{c}, hmm.mu{c}, hmm.Sigma{c}, ...
            hmm.mixmat{c}, hmm.term{c}, isDiag);
      end
    end
    [~, mlPred] = max(ll);
    pred1(startNdx : endNdx) = mlPred;
    path1(startNdx : endNdx) = viterbi_path(hmm.prior{mlPred}, ...
        hmm.transmat{mlPred}, obslik{mlPred}, hmm.term{mlPred});
    prob1{r} = ll;
  end
  pred{i} = pred1;
  prob{i} = prob1;
  path{i} = path1;
end
end
