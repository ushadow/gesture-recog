function [prior, transmat, term, mu, Sigma, mixmat] = inithmmparam(...
    data, nS, M, cov_type, gestureNDX)
%
% ARGS
% data  - cell arrays of observation sequence. data{i}(:, j) is the jth 
%         observation in ith sequence.
% nS    - number of hidden states S.
% M     - number of mixtures.
%
% RETURNS
% mu    - d x nS x M matrix where d is the dimention of the observation.

% Uniform initialization.
% prior = ones(nS, 1) / nS;
% transmat = ones(nS) / nS;
% term = ones(nS, 1) / nS;
mixmat = ones(nS, M) / M;

if gestureNDX <= 10
  [prior, transmat, term] = makebakistrans(nS);
else
  [prior, transmat, term] = makepreposttrans(nS);
end

[mu, Sigma] = mixgauss_init(nS * M,  cell2mat(data), cov_type);
d = size(mu, 1);
mu = reshape(mu, [d nS M]);
Sigma = reshape(Sigma, [d d nS M]);
end