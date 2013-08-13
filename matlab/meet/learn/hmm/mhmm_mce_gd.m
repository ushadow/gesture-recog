function [prior, transmat, term, mu, sigma2, mixmat] = mhmm_mce_gd(...
    dataByClass, prior, transmat, term, mu, sigma2, mixmat)
%
% ARGS
% dataByClass   - ngestures x nstages cell array. Each cell array is
%   a cell array of sequences. Does not include rest data.
% prior   - cell array

numIter = 1;
maxIter = 10;
converged = false;

ngestures = size(dataByClass, 1);
gestureNDX = 1 : ngestures;
gprior = cat(3, prior{gestureNDX, 2});
gtransmat = cat(3, transmat{gestureNDX, 2});
gterm = cat(3, term{gestureNDX, 2});
gmu = cat(4, mu{gestureNDX, 2});
gsigma2 = cat (5, sigma2{gestureNDX, 2});
gsigma = sqrt(gsigma2);
gmixmat = cat(3, mixmat{gestureNDX, 2});

while (numIter <= maxIter) && ~converged
  [gprior, gtransmat, gterm, gmu, gsigma, gmixmat] = gradmhmm(...
    dataByClass, gprior, gtransmat, gterm, gmu, gsigma, gmixmat);
  numIter = numIter + 1;
end

[O, Q, M, ~] = size(gmu);
prior(gestureNDX, 2) = mat2cell(gprior, Q, 1, ones(1, ngestures));
transmat(gestureNDX, 2) = mat2cell(gtransmat, Q, Q, ones(1, ngestures));
term(gestureNDX, 2) = mat2cell(gterm, Q, 1, ones(1, ngestures));
mu(gestureNDX, 2) = mat2cell(gmu, O, Q, M, ones(1, ngestures));
sigma2(gestureNDX, 2) = mat2cell(gsigma .^ 2, O, O, Q, M, ones(1, ngestures));
mixmat(gestureNDX, 2) = mat2cell(gmixmat, Q, M, ones(1, ngestures));
end

function [prior, transmat, term, mu, sigma, mixmat] = gradmhmm(...
    dataByClass, prior, transmat, term, mu, sigma, mixmat)
%
% ARGS
% dataByClass - vocabulary size x nstages cell arrays. Each cell arrays is 
%   a cell arrayd of sequences.
% sigma - sqrt of covariance matrix.

eta = 1;
varsigma = 0.02; % Inversely proportional to average sequence length.

[O, Q, M, ngestures] = size(mu);
sigma2 = sigma .^ 2;
covPrior = repmat(0.01 * eye(O, O), [1 1 Q, M, ngestures]);

gziSum = zeros(Q, 1, ngestures);
gzijSum = zeros(Q, Q, ngestures);
gzendSum = zeros(Q, 1, ngestures);
gmixSum = zeros(Q, M, ngestures);
gmuSum = zeros(O, Q, M, ngestures);
gsigmaSum = zeros(O, O, Q, M, ngestures);

for i = 1 : ngestures
  X = dataByClass{i, 2};
  nseqs = length(X);
  for k = 1 : nseqs
    ll = zeros(1, ngestures);
    for j = 1 : ngestures
       
      [B, B2] = mixgauss_prob(X{k}, mu(:, :, :, j), sigma2(:, :, :, :, j), ...
          mixmat(:, :, j));

      [~, ~, gamma, ll(j), xi_summed, gamma2] = fwdback(prior(:, :, j), transmat(:, :, j), ...
          B, 'obslik2', B2, 'mixmat', mixmat(:, :, j), 'term', term(:, :, j));
      if j == i
        gzi = gamma(:, 1) .* (1 - prior(:, :, j));
        gzij = xi_summed .* (1 - transmat(:, :, j));
        gzend = gamma(:, size(B, 2)) .* (1 - term(:, :, j));
        [gmix, gmu, gsigma] = gradgaussian(X{k}, mixmat(:, :, j), ...
            mu(:, :, :, j), sigma(:, :, :, :, j), sigma2(:, :, :, :, j), gamma2);
      end
    end
    logdebug('mhmm_mce_gd', 'loglik', ll);
    d = -ll(i) + max(ll([1 : i - 1, i + 1 : end]));
    epsilon = 1 / (1 + exp(-varsigma * d));
    weight = -varsigma * epsilon * (1 - epsilon);       
    gziSum(:, :, i) = gziSum(:, i) + weight * gzi;
    gzijSum(:, :, i) = gzijSum(:, :, i) + weight * gzij;
    gzendSum(:, :, i) = gzendSum(:, i) + weight * gzend;
    gmuSum(:, :, :, i) = gmuSum(:, :, :, i) + weight * gmu;
    gmixSum(:, :, i) = gmixSum(:, :, i) + weight * gmix;
    gsigmaSum(:, :, :, :, i) = gsigmaSum(:, :, :, :, i) + weight * gsigma;   
  end
end
prior = prior .* exp(-eta * gziSum);
prior = bsxfun(@(x, y) x ./ y, prior, sum(prior, 1));
transmat = transmat .* exp(-eta * gzijSum);
transmatDenom = sum(transmat, 2);
transmat = bsxfun(@(x, y) x ./ y, transmat, transmatDenom);
termNew = term .* exp(-eta * gzendSum);
termDenom = termNew + transmatDenom .* (1 - term);
term = termNew ./ termDenom;
mu = mu - eta * gmuSum;
mixmat = mixmat .* exp(-eta * gmixSum);
mixmat = bsxfun(@(x, y) x ./ y, mixmat, sum(mixmat, 2));
sigma = sigma - eta * gsigmaSum + covPrior;
end

function [gmix, gmu, gsigma] = gradgaussian(obs, mixmat, ...
      mu, sigma, sigma2, gamma2)
%
% ARGS
% gamma2  - gamma2(j,k,t) = p(Q(t)=j, M(t)=k | y(1:T))

[O, Q, M] = size(mu);
T = size(obs, 2);
gmu = zeros(O, Q, M);
gsigma = zeros(O, O, Q, M);

gmix = sum(gamma2, 3) .* (1 - mixmat);

for i = 1 : Q
  for k = 1 : M
    w = reshape(gamma2(i, k, :), [1 T]);
    sumw = sum(w, 2);
    wobs = obs .* repmat(w, [O, 1]);
    diagSigma2 = diag(sigma2(:, :, i, k));
    diagSigma = diag(sigma(:, :, i, k));
    gmu(:, i, k) = (sum(wobs, 2) -  sumw * mu(:, i, k)) ./ diagSigma2; 
    op = wobs * obs' - mu(:, i, k) * mu(:, i, k)' * sumw; % O x O 
    full = -op ./ repmat(diagSigma2 .* diagSigma, [1 O]) - diag(sumw ./ diagSigma);
    gsigma(:, :, i, k) = diag(diag(full));
  end
end
end