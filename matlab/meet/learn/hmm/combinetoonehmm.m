function combinedModel = combinetoonehmm(prior, transmat, term, mu, Sigma, mixmat)
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

combinedModel.prior = cat(1, prior{:});
combinedModel.prior = single(normalise(combinedModel.prior));

nHmms = length(prior);

nTotalStates = length(combinedModel.prior);
combinedModel.transmat = zeros(nTotalStates);
combinedModel.term = cat(1, term{:});
combinedTerm = repmat(combinedModel.term, 1, nTotalStates);

sNDX =1;
for i = 1 : nHmms
  nStates = length(prior{i});
  eNDX = sNDX + nStates - 1;
  combinedModel.transmat(sNDX : eNDX, sNDX : eNDX) = transmat{i};  
  sNDX = eNDX + 1;
end

combinedModel.transmat = single(combinedModel.transmat .* (1 - combinedTerm) + ... 
    repmat(combinedModel.prior', nTotalStates, 1) .* combinedTerm);

combinedModel.mu = single(cat(2, mu{:}));
combinedModel.Sigma = single(cat(3, Sigma{:}));
combinedModel.mixmat = single(cat(1, mixmat{:})');
end