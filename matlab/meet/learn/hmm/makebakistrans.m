function [prior, transmat, term] = makebakistrans(nS)
%
% RETURNS
% prior   - column vector
% term    - column vector

N = 3;
p = 1 / N;
assert(nS >= N, sprintf('Number of states must be greater than %d', N));

prior = zeros(nS, 1);
prior(1 : N - 1) = 1 / (N - 1);
transmat = diag(ones(nS, 1)) * p + diag(ones(nS - 1, 1), 1) * p + ...
           diag(ones(nS - 2, 1), 2) * p;
transmat(nS - 1, [1, nS - 1 : nS]) = 1 / N;
transmat(nS, [1 nS]) = 1 / (N - 1);

term = zeros(nS, 1);
term(nS - N + 2 : nS) = p;
end