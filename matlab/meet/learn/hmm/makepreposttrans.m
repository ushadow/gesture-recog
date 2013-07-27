function [prior, transmat, term] = makepreposttrans(nS)
prior = ones(nS, 1) / nS;
transmat = eye(nS);
term = ones(nS, 1) * 0.5;
end