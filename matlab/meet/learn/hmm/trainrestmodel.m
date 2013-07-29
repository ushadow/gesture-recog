function [prior, transmat, mu, Sigma, mixmat, term] = trainrestmodel(X, nM)
%% TRAINRESTMODEL trains a mixture of Gaussian model for rest positions.
%
% ARGS
% nM  - number of mixtures.

X = cell2mat(X);
nX = size(X, 1);
nS = 1; % One hidden state for the rest position, i.e. no motion.

prior = 1;
transmat = 1;
mu = zeros(nX, nS, nM);
mu(:, 1, 1) = mean(X, 2);

Sigma = repmat(eye(nX), [1, 1, nS, nM]);
Sigma(:, :, 1, 1) = diag(std(X, 0, 2));

mixmat = zeros(nS, nM);
mixmat(1) = 1;
term = 0.5;
end