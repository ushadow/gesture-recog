function combinedModel = combinetoonehmm(prior, transmat, term, mu, ...
    Sigma, mixmat, param)
%%
% COMBINETOONEHMM combines all HMMs to one HMM.
%
% ARGS
% prior   - cell array of column vectors.
% transmat(i, j) = p(s(j) | s(i))
% mu : p x n matrix where p is the feature length and n is the number of 
%      states.
% Sigma: p x p x n
% mixmat: n x m matrix where m is number of mixtures.
%
% RETURNS
% The combined model in single precision.
% combinedModel.mixmat is a m x nTotalStates matrix.

% Prior
combinedModel.prior = cat(1, prior{:});
combinedModel.prior = normalise(combinedModel.prior);

nHmms = length(prior);
nTotalStates = length(combinedModel.prior);

% Termination
combinedModel.term = cat(1, term{:});
combinedTerm = repmat(combinedModel.term, 1, nTotalStates);

% Transition
combinedModel.transmat = zeros(nTotalStates);
sNDX =1;
for i = 1 : nHmms
  nStates = length(prior{i});
  eNDX = sNDX + nStates - 1;
  combinedModel.transmat(sNDX : eNDX, sNDX : eNDX) = transmat{i};  
  sNDX = eNDX + 1;
end

combinedModel.transmat = combinedModel.transmat .* (1 - combinedTerm) + ... 
    repmat(combinedModel.prior', nTotalStates, 1) .* combinedTerm;

combinedModel.transmat = allowpretosingle(combinedModel.transmat, ...
    param.gestureType, param.nS);

[combinedModel.labelMap, combinedModel.stageMap] = ...
    maphiddenstatetolabel(nTotalStates, param.nS, param.gestureType);  
combinedModel.mu = single(cat(2, mu{:}));
combinedModel.Sigma = single(cat(3, Sigma{:}));
combinedModel.mixmat = single(cat(1, mixmat{:}));
end

function [labelMap, stageMap] = maphiddenstatetolabel(totalNStates, nS, ...
    gestureType)
% ARGS
% nS  - number of hidden states for gestures with dynamic paths.
%
% RETURNS
% stageMap  - maps hidden states to gesture stages.

labelMap = zeros(1, totalNStates);
stageMap = cell(1, totalNStates);
startNdx = 1;
for i = 1 : length(gestureType)
  if gestureType(i) == 1
    endNdx = startNdx + nS - 1;
    stageMap{startNdx} = 'PreStroke';
    stageMap{endNdx} = 'PostStroke';
    [stageMap{startNdx + 1 : endNdx - 1}] = deal('Gesture');
  else
    endNdx = startNdx;
    stageMap{startNdx} = 'Gesture';
  end
  labelMap(startNdx : endNdx) = i;
  
  startNdx = endNdx + 1;
end
labelMap = int32(labelMap);
end

function transmat = allowpretosingle(transmat, gestureType, nS)
preStates = [];
singleStates = [];
startNdx = 1;
for gt = gestureType
  nStates = 1;
  if gt == 1
    preStates = [preStates startNdx];  %#ok<AGROW>
    nStates = nS;
  else
    singleStates = [singleStates startNdx]; %#ok<AGROW>
  end
  startNdx = startNdx + nStates;
end
transmat(preStates, singleStates) = 0.01;
transmat = mk_stochastic(transmat); 
end