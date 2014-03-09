function combinedModel = combinetoonehmm(prior, transmat, term, mu, ...
    Sigma, mixmat, obsmat, param)
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

if param.hasDiscrete
  combinedModel.obsmat = cat(1, obsmat{:});
end

% Prior
combinedModel.prior = cat(1, prior{:});
combinedModel.prior = normalise(combinedModel.prior);

nHmms = length(prior);
nTotalStates = length(combinedModel.prior);

% Termination
combinedModel.term = cat(1, term{:});
combinedTerm = repmat(combinedModel.term, 1, nTotalStates);

[combinedModel.labelMap, combinedModel.stageMap] = ...
    maphiddenstatetolabel(nTotalStates, param.nS, param.vocabularySize); 

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

combinedModel.transmat = addprepost(combinedModel.transmat, ...
    param.gestureType, combinedModel.stageMap, combinedModel.labelMap);

combinedModel.nM = cellfun(@(x) size(x, 3), mu);
maxM = max(combinedModel.nM);
d = size(mu{1}, 1);
mu = adddefaultmat(mu, zeros(d, 1), 3, maxM);
Sigma = adddefaultmat(Sigma, eye(d), 4, maxM);
mixmat = adddefaultmat(mixmat, 0, 2, maxM);

combinedModel.mu = single(cat(2, mu{:}));
combinedModel.Sigma = single(cat(3, Sigma{:}));
combinedModel.mixmat = single(cat(1, mixmat{:}));
end

function [labelMap, stageMap] = maphiddenstatetolabel(totalNStates, nS, vocabSize)
% ARGS
% nS  - number of hidden states for gestures with dynamic paths.
% gestureType   - array of gesture type for each gesture.
%
% RETURNS
% labelMap  - 1-based indices of gesture labels.
% stageMap  - maps hidden states to gesture stages.

labelMap = zeros(1, totalNStates);
stageMap = cell(1, totalNStates);
startNdx = 1;
for i = 1 : vocabSize
  nStates = nS(i);
  if nStates > 1
    endNdx = startNdx + nStates - 1;
    stageMap{startNdx} = 'PreStroke';
    [stageMap{endNdx}] = deal('PostStroke');
    [stageMap{startNdx + 1 : endNdx - 1}] = deal('Gesture');
  else
    endNdx = startNdx;
    stageMap{startNdx} = 'Gesture';
  end
  labelMap(startNdx : endNdx) = i;
  
  startNdx = endNdx + 1;
end
stageMap{end} = 'Rest';
labelMap = int32(labelMap);
end

function transmat = addprepost(transmat, gestureType, stageMap, labelMap)
%% ADDPREPOST add pre- and post-stage transitions

nStates = length(stageMap);
for i = 1 : nStates
  switch stageMap{i}
    case 'PreStroke'
      % PreStroke can go to a single state gesture or another PreStroke
      % state.
      for j = 1 : nStates
        if j ~= i && (strcmp(stageMap{j}, 'PreStroke') || ~strcmp(gestureType(labelMap(j)), 'D'))
          transmat(i, j) = 0.01;
        end
      end
    case 'PostStroke'
      for j = 1 : nStates
        if j ~= i && (strcmp(stageMap{j}, 'PostStroke') || ~strcmp(gestureType(labelMap(j)), 'D'))
          transmat(j, i) = 0.01;
        end
      end
  end
end
transmat = mk_stochastic(transmat); 
end