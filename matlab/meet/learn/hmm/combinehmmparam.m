function [combinedPrior, combinedTransmat, combinedTerm, combinedMu, ...
    combinedSigma, combinedMixmat] = combinehmmparam(prior, transmat, ...
    term, mu, Sigma, mixmat)
%%
% Combines pre-stroke, nucleus and post-stroke HMMs together.
%
% ARGS
% prior   - cell array of column vectors.
% term    - cell array of column vectors.

combinedPrior = cat(1, prior{:});
combinedPrior(length(prior{1}) + 1 : end) = 0;

nS = cellfun(@(x) length(x), prior);
totalNumStates = length(combinedPrior);

combinedTransmat = zeros(totalNumStates);
startNDX = 1;
for i = 1 : length(nS)
  p = 1;
  endNDX = startNDX + nS(i) - 1;
  
  if i ~= length(nS)
    combinedTransmat(startNDX : endNDX, endNDX + 1 : endNDX + nS(i + 1)) = ...
        term{i} * prior{i + 1}';
    p = 1 - repmat(term{i}, 1, nS(i));
  end
  
  combinedTransmat(startNDX : endNDX, startNDX : endNDX) = transmat{i} .* p;
  startNDX = startNDX + nS(i);
end

combinedTerm = cat(1, term{:});
combinedTerm(1 : end - nS(end)) = 0;
assert(abs(sum(combinedPrior) - 1) < 1e-9);

if nargout > 3
  combinedMu = cat(2, mu{:});
end

if nargout > 4
  combinedSigma = cat(3, Sigma{:});
  combinedMixmat = cat(1, mixmat{:});
end
end