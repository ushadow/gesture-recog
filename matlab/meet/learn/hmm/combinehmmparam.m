function [combinedPrior, combinedTransmat, combinedMu, combinedSigma, ...
    combinedMixmat, combinedTerm] = combinehmmparam(prior, transmat, ...
    mu, Sigma, mixmat, term)
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

combinedMu = cat(2, mu{:});
combinedSigma = cat(3, Sigma{:});
combinedMixmat = cat(1, mixmat{:});
combinedTerm = cat(1, term{:});
combinedTerm(1 : end - nS(end)) = 0;
end