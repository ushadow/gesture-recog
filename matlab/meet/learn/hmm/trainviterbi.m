function [prior, transmat, mu, Sigma, mixmat, term] = trainviterbi(data, ...
    prior, transmat, nM, varargin)
%
% ARGS
% data{ex}(:,t)
% nM - number of mixtures.

Q = length(prior);
d = size(data{1}, 1);
[maxIter, covType,  adjPrior, adjTrans, term, adjTerm, featureNdx] = ...
    process_options(varargin, 'max_iter', 10, ...
		    'cov_type', 'full', 'adj_prior', 1, 'adj_trans', 1, ...
        'term', ones(Q, 1), 'adj_term', 1, 'feature_ndx', 1 : d);

[mu, Sigma, mixmat] = initmixgaussequaldiv(data, Q, nM, covType, featureNdx);

nIter = 1;      
while (nIter <= maxIter)
  [nTrans, nVisit1, nVisitT, mixmat, mu, Sigma] = essmhmm(prior, transmat, ...
      mixmat, mu, Sigma, data, term, covType, featureNdx);
  
  if adjPrior
    prior = normalise(nVisit1);
  end
  if adjTrans
    [transmat, Z] = mk_stochastic(nTrans);
  end
  if adjTerm
    A = mk_stochastic([Z nVisitT]);
    term = A(:, end);
  end
  nIter = nIter + 1;
end
end

function [nTrans, nVisit1, nVisitT, mixmat, mu, Sigma] = ...
    essmhmm(prior, transmat, mixmat, mu, Sigma, data, term, covType, featureNdx)

numex = length(data);
Q = length(prior);
M = size(mixmat, 2);
nTrans = zeros(Q, Q);
nVisit1 = zeros(Q, 1);
nVisitT = zeros(Q, 1);
segX = cell(Q, 1);

for ex = 1 : numex
  obs = data{ex}(featureNdx, :);
  T = size(obs, 2);
  B = mixgauss_prob(obs, mu, Sigma, mixmat);
  path = viterbi_path(prior, transmat, B, term);
  for i = 1 : T - 1
    nTrans(path(i), path(i + 1)) = nTrans(path(i), path(i + 1)) + 1; 
  end
  nVisit1(path(1)) = nVisit1(path(1)) + 1;
  nVisitT(path(T)) = nVisitT(path(T)) + 1;
  
  for i = 1 : Q
    segX{i} = [segX{i} obs(:, path == i)];
  end
end

for i = 1 : Q
  if size(segX{i}, 2) >= M
    % Use K-means to initialize the centers of mixture of Gaussians.
    [mu(:, i, :), Sigma(:, :, i, :), mixmat(i, :)] = mixgauss_init(M, ...
        segX{i}, covType);
  else
    mu(:, i, :) = repmat(mean(segX{i}, 2), [1, M]);
    Sigma(:, :, i, :) = repmat(diag(std(segX{i}, 0, 2)), [1, M]);
    mixmat(i, :) = ones(1, M) / M;
  end
end
end