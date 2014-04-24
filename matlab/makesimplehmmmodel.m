function [prior, transmat, mu, Sigma, mixmat, term] = makesimplehmmmodel(X, ...
          sampleRate, nM, covType, featureNdx)
%% MAKESIMPLEHMMMODEL Creates a simple one state HMM model.
% ARGS
% nM  - 1-by-2 vector

% Transition parameters
prior = 1;
transmat = 1;

MIN_LEN = 30;
term = 1 * sampleRate / MIN_LEN;        
        
% Emission parameters
X = cell2mat(X);
X = X(featureNdx, :)';

[mu, Sigma, mixmat] = gmmfitbic(X, nM(1), nM(2), covType);
end

function [mix, ll] = gmmkpm() %#ok<DEFNU>
  mix = gmm(d, m, covType);
  options = foptions;
  options(1) = -1;
  options(14) = 10;
  % Initialization
  mix = gmminit(mix, X, options);
  [mix, ~, ll] = gmmem_kpm(mix, X, 'max_iter', 100);
end

function [mix, ll] = gmmkpmmultirestart(M, X, covType)
d = size(X, 2);
nRestarts = 3;
mix = gmm(d, M, covType);
options = foptions;
options(1) = -1;
options(14) = 5;
% Initialization
initMeans = zeros(M, d, nRestarts);
initSigma = zeros(M, d, nRestarts);
for i = 1 : nRestarts
  mix = gmminit(mix, X, options);
  initMeans(:, :, i) = mix.centres;
  initSigma(:, :, i) = mix.covars;
end

[mix.centres, mix.covars, mix.priors, ll] = gmmem_multi_restart(M, X, ...
    'nrestarts', 3, 'cov_type', covType, 'max_iter', 100, ...
    'init_means', initMeans, 'init_cov', initSigma);
mix.ncentres = M;
end

function [mu, Sigma, mixmat] = gmmfitbic(X, minM, maxM, covType) 
%% GMMFITBIC Fit a Gaussian mixture model and choose the number of mixtures
%   according to BIC.

[n, d] = size(X);
bestBIC = -inf;

for m = minM : maxM
  [mix, ll] = gmmkpmmultirestart(m, X, covType);
  nParams = (mix.ncentres - 1) + (d + d) * mix.ncentres;
  bic = 2 * ll - log(n) * nParams;
  if bic > bestBIC
    bestBIC = bic;
    bestModel = mix;
  end
end
nM = bestModel.ncentres;
mu = reshape(bestModel.centres', [d 1 nM]);
Sigma = zeros(d, d, 1, nM);
for i = 1 : nM
  Sigma(:, :, 1, i) = diag(bestModel.covars(i, :));
end
mixmat = reshape(bestModel.priors, [1 nM]);
end

function [mu, Sigma, mixmat] = gmmfitbic2(X, minM, maxM, covType) %#ok<DEFNU>
%
% ARGS
% X   - a n-by-d matrix where n is number of data points.
% mixInit   - a struct with 
%   mu  - a m-by-d matrix where m is number of mixtures.
%   covars - m-by-d matrix

bestBIC = -inf;
d = size(X, 2);

for i = minM : maxM
  mix = gmm(d, i, covType);
  options = foptions;
  options(1) = -1;
  options(14) = 5;
  mix = gmminit(mix, X, options);

  S.mu = mix.centres;
  S.Sigma = zeros(1, d, i);
  S.Sigma(1, :, :) = mix.covars';
  S.PComponents = mix.priors;
  obj = gmdistribution.fit(X, i, 'Start', S, 'CovType', 'diagonal', ...
      'Regularize', 0.01);
  if obj.BIC > bestBIC
    bestBIC = obj.BIC;
    bestModel = obj;
  end
end
nM = bestModel.NComponents;
mu = reshape(bestModel.mu', [d 1 nM]);
Sigma = zeros(d, d, 1, nM);
for i = 1 : nM
  Sigma(:, :, 1, i) = diag(bestModel.Sigma(1, : , i));
end
mixmat = reshape(bestModel.PComponents, [1 nM]);
end