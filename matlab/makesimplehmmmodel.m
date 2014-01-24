function [prior, transmat, mu, Sigma, mixmat, term] = makesimplehmmmodel(X, ...
          sampleRate, nM)
%% MAKESIMPLEHMMMODEL Creates a simple one state HMM model.

% Transition parameters
prior = 1;
transmat = 1;

MIN_LEN = 30;
term = 1 * sampleRate / MIN_LEN;        
        
% Emission parameters
X = cell2mat(X);
d = size(X, 1);
nS = 1;

mu = zeros(d, nS, nM);
mu(:, 1, 1) = mean(X, 2);
Sigma = repmat(eye(d), [1, 1, nS, nM]);
% Use default normalization by N - 1.
Sigma(:, :, 1, 1) = diag(var(X, 0, 2));
mixmat = zeros(nS, nM);
mixmat(1) = 1;
end