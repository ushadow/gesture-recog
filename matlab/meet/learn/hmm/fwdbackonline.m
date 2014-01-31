function path = fwdbackonline(prior, transmat, obslik, varargin)

scaled = 1;

T = size(obslik, 2);
prior = prior(:);
Q = length(prior);

[term, lag] = process_options(varargin, 'term', ones(Q, 1), 'lag', 0);

alpha = zeros(Q, T);
beta = zeros(Q, T);
scale = ones(1, T);
path = zeros(1, T);

t = 1;
alpha(:, t) = prior .* obslik(:,t);
if scaled
  [alpha(:, t), scale(t)] = normalise(alpha(:, t));
end

for t = 2 : T
  m = transmat' * alpha(:, t - 1);
  alpha(:, t) = m(:) .* obslik(:, t);
  if scaled
    [alpha(:, t), scale(t)] = normalise(alpha(:, t));
  end
end
alpha(:, T) = alpha(:, T) .* term;

for t = 1 : T
  beta(:, t) = ones(Q, 1);
  [~, path(t)] = max(alpha(:, t));
  for tau = t - 1 : -1 : max(1, t - lag)
    b = beta(:, tau + 1) .* obslik(:, tau + 1);
    beta(:, tau) = transmat * b;
    if scaled
      beta(:, tau) = normalise(beta(:, tau));
    end
    gamma = alpha(:, tau) .* beta(:, tau);
    [~, path(tau)] = max(gamma);
  end
end