function path = viterbionline(prior, transmat, obslik, varargin)
scaled = 1;

T = size(obslik, 2);
prior = prior(:);
Q = length(prior);

[term, lag] = process_options(varargin, 'term', ones(Q, 1), 'lag', 0);


delta = zeros(Q,T);
psi = zeros(Q,T);
path = zeros(1,T);
scale = ones(1,T);

t=1;
delta(:,t) = prior .* obslik(:,t);
if scaled
  [delta(:,t), n] = normalise(delta(:,t));
  scale(t) = 1/n;
end
psi(:,t) = 0; % arbitrary value, since there is no predecessor to t=1
for t=2:T
  for j=1:Q
    [delta(j,t), psi(j,t)] = max(delta(:,t-1) .* transmat(:,j));
    delta(j,t) = delta(j,t) * obslik(j,t);
  end
  if scaled
    [delta(:,t), n] = normalise(delta(:,t));
    scale(t) = 1/n;
  end
end

delta(:, T) = delta(:, T) .* term;

for t = lag + 1 : T
  [~, path(t)] = max(delta(:, t));
  for tau = t - 1 : -1 : t - lag
    path(tau) = psi(path(tau + 1), tau + 1);
  end
end