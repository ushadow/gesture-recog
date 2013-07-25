function [prior, transmat, term, mu, Sigma, mixmat] = inithmmparam(...
    data, nS, M, cov_type)
%
% ARGS
% data  - cell arrays of observation sequence. data{i}(:, j) is the jth 
%         observation in ith sequence.
% nS    - number of hidden states S.
% M     - number of mixtures.

% Uniform initialization.
prior = ones(nS, 1) / nS;
transmat = ones(nS) / nS;
term = ones(nS, 1) / nS;
mixmat = ones(nS, M) / M;

[mu, Sigma] = mixgauss_init(nS * M,  cell2mat(data), cov_type);
d = size(mu, 1);
mu = reshape(mu, [d nS M]);
end