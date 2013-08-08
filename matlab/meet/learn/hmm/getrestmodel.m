function [prior, transmat, mu, Sigma, mixmat, term] = getrestmodel( ...
    restMu, restSigma, restMixmat, nM)
%% TRAINRESTMODEL creates HMM for rest positions.
%
% ARGS
% mu, Sigma, mixmat   - Gaussian parameters for the rest model.
% nM  - number of mixtures.

nX = size(restMu, 1);
nS = 1; % One hidden state for the rest position, i.e. no motion.

prior = 1;
transmat = 1;
term = 0.5;

if size(restMu, 3) ~= nM
  mu = zeros(nX, nS, nM);
  mu(:, 1, 1) = restMu;
  Sigma = repmat(eye(nX), [1, 1, nS, nM]);
  Sigma(:, :, 1, 1) = restSigma;  
  mixmat = zeros(nS, nM);
  mixmat(1) = restMixmat;
else
  mu = restMu;
  Sigma = restSigma;
  mixmat = restMixmat;
end

end