function [prior, transmat, term] = makeembedtrans(nS, rep)
if nargin < 2
  rep = 1;
end

N = 3;
p = 1 / N;
assert(nS >= N, sprintf('Number of states must be greater than %d', N));

prior = zeros(nS, 1);
prior(1) = 1;
transmat = diag(ones(nS, 1)) * p + diag(ones(nS - 1, 1), 1) * p + ...
           diag(ones(nS - 2, 1), 2) * p;

if rep
  toNdx = [2, nS - 1 : nS];
else
  toNdx = nS - 1 : nS; 
end
transmat(nS - 1, toNdx) = 1 / length(toNdx); 

toNdx = nS;
transmat(nS, toNdx) = 1 / length(toNdx);

term = zeros(nS, 1);
term(nS) = 1 / 15;
end