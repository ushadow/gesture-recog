function [combinedPrior, combinedTransmat, combinedTerm, combinedMu, ...
    combinedSigma, combinedMixmat] = combinehmmparam(prior, transmat, ...
    term, mu, Sigma, mixmat, nSMap)
%%
% Combines pre-stroke, nucleus and post-stroke HMMs together.
%
% ARGS
% prior   - cell array of column vectors.
% term    - cell array of column vectors.

stageNdx = gesturestagendx(nSMap);
nStages = size(stageNdx, 1);

combinedPrior = cat(1, prior{:});
combinedPrior(stageNdx(3, 1) : stageNdx(3, 2)) = 0;
combinedPrior = normalise(combinedPrior);
assert(abs(sum(combinedPrior) - 1) < 1e-9);

totalNumStates = length(combinedPrior);

combinedTransmat = zeros(totalNumStates);
for i = 1 : nStages
  nextStage = mod(i, nStages) + 1; 
  fromNdx = stageNdx(i, 1) : stageNdx(i, 2);
  toNdx = stageNdx(nextStage, 1) : stageNdx(nextStage, 2);
  combinedTransmat(fromNdx, toNdx) = term{i} * prior{nextStage}';
  
  p = 1 - repmat(term{i}, 1, length(fromNdx));
  combinedTransmat(fromNdx, fromNdx) = transmat{i} .* p;
end
% Allow pre-stroke to transit to post-stroke.
combinedTransmat(stageNdx(1, 2) - 2 : stageNdx(1, 2), ...
          stageNdx(3, 1) : stageNdx(3, 1) + 2) = 0.01;
combinedTransmat = mk_stochastic(combinedTransmat);

combinedTerm = cat(1, term{:});
combinedTerm(stageNdx(1, 1) : stageNdx(2, 2)) = 0;
% Allow pre-stroke to terminate.
combinedTerm(stageNdx(1, 2) - 2 : stageNdx(1, 2)) = ones(3, 1) * 0.01;
        
if nargout > 3
  combinedMu = cat(2, mu{:});
end

if nargout > 4
  combinedSigma = cat(3, Sigma{:});
  combinedMixmat = cat(1, mixmat{:});
end
end