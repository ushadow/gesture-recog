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

combinedModel.prior = cat(1, prior{:});
combinedModel.prior = single(normalise(combinedModel.prior));

nHmms = length(prior);

nStates = length(prior{1});
nTotalStates = length(combinedModel.prior);
combinedModel.transmat = zeros(nTotalStates);

combinedTerm = repmat(cat(1, term{:}), 1, nTotalStates);

for i = 0 : nHmms - 1
  sNDX = 1 + nStates * i;
  eNDX = sNDX + nStates - 1;
  combinedModel.transmat(sNDX : eNDX, sNDX : eNDX) = transmat{i + 1};  
end

combinedModel.transmat = single(combinedModel.transmat .* (1 - combinedTerm) + ... 
    repmat(combinedModel.prior', nTotalStates, 1) .* combinedTerm);

combinedModel.mu = single(cat(2, mu{:}));
combinedModel.Sigma = single(cat(3, Sigma{:}));
combinedModel.mixmat = single(cat(1, mixmat{:})');
end