function [combinedPrior, combinedTransmat, combinedTerm, combinedMu, ...
    combinedSigma, combinedMixmat] = combinehmmparamwithrest(hmm, ...
    nSMap, gestureNdx, restNdx)
%%
% Combines pre-stroke, nucleus and post-stroke HMMs together.
%
% ARGS
% prior   - cell array of column vectors.
% term    - cell array of column vectors.
% i   - gesture index;

stageNdx = gesturestagendx(nSMap);
nStages = size(stageNdx, 1);

prior = hmm.prior(gestureNdx, :);
transmat = hmm.transmat(gestureNdx, :);
term = hmm.term(gestureNdx, :);
mu = hmm.mu(gestureNdx, :); 
Sigma = hmm.Sigma(gestureNdx, :);
mixmat = hmm.mixmat(gestureNdx, :);

combinedPrior = cat(1, prior{:});
combinedPrior(stageNdx(2, 1) : stageNdx(3, 2)) = 0;
combinedPrior = normalise(combinedPrior);
assert(abs(sum(combinedPrior) - 1) < 1e-9);

totalNumStates = length(combinedPrior);

%% Combine transmat
combinedTransmat = zeros(totalNumStates);
for i = 1 : nStages
  p = 1;
  
  fromNdx = stageNdx(i, 1) : stageNdx(i, 2);
  
  if i < nStages
    nextStage = i + 1; 
    toNdx = stageNdx(nextStage, 1) : stageNdx(nextStage, 2);
    combinedTransmat(fromNdx, toNdx) = term{i} * prior{i + 1}';
    p = 1 - repmat(term{i}, 1, nSMap(i));
  end
  
  combinedTransmat(fromNdx, fromNdx) = transmat{i} .* p;
end

%% Combine term
combinedTerm = cat(1, term{:});
combinedTerm(stageNdx(1, 1) : stageNdx(2, 2)) = 0;
        
if nargout > 3
  combinedMu = cat(2, mu{:});
end

if nargout > 4
  combinedSigma = cat(3, Sigma{:});
  combinedMixmat = cat(1, mixmat{:});
end

[combinedPrior, combinedTransmat, combinedTerm, combinedMu, ...
    combinedSigma, combinedMixmat] = combinerestmodel(combinedPrior, combinedTransmat, ...
    combinedTerm, hmm.transmat{restNdx, 1}, hmm.term{restNdx, 1}, nSMap, ...
    combinedMu, hmm.mu{restNdx, 1}, combinedSigma, combinedMixmat, hmm.Sigma{restNdx, 1}, ...
    hmm.mixmat{restNdx, 1});
end