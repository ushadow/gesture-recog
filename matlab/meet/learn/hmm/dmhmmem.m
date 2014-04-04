function [LL, prior, transmat, mu, Sigma, mixmat, term, obsmat] = ...
    dmhmmem(data, prior, transmat, mu, Sigma, mixmat, obsmat, varargin)
%% DMHMMEM EM alogrithm for both discrete and mix of Gaussians output.
%
% ARGS
% obsmat(i, o)

if ~isempty(varargin) && ~ischar(varargin{1}) % catch old syntax
  error('optional arguments should be passed as string/value pairs')
end

Q = length(prior);

[max_iter, thresh, verbose, cov_type,  adj_prior, adj_trans, adj_mix, ...
    adj_mu, adj_Sigma, term, adj_term, adj_obs, obs_prior_weight] = ...
    process_options(varargin, 'max_iter', 10, 'thresh', 1e-4, 'verbose', 1, ...
		    'cov_type', 'full', 'adj_prior', 1, 'adj_trans', 1, 'adj_mix', 1, ...
		    'adj_mu', 1, 'adj_Sigma', 1, 'term', ones(Q, 1), 'adj_term', 1, ...
        'adj_obs', 1, 'obs_prior_weight', 0);
  
previous_loglik = -inf;
converged = 0;
num_iter = 1;
LL = [];

if ~iscell(data)
  data = num2cell(data, [1 2]); % each elt of the 3rd dim gets its own cell
end

O = size(mu, 1);

if isempty(mixmat)
  mixmat = ones(Q,1);
end
M = size(mixmat,2);
if M == 1
  adj_mix = 0;
end

while (num_iter <= max_iter) && ~converged
  % E step
  [loglik, exp_num_trans, exp_num_visits1, postmix, m, ip, op, exp_num_visitsT, exp_num_emit] = ...
      ess_dmhmm(prior, transmat, mixmat, mu, Sigma, data, term, obsmat, obs_prior_weight);
  
  
  % M step
  if adj_prior
    prior = normalise(exp_num_visits1);
  end
  if adj_trans 
    [transmat, Z] = mk_stochastic(exp_num_trans);
  end
  if adj_mix
    mixmat = mk_stochastic(postmix);
  end
  if adj_mu || adj_Sigma
    [mu2, Sigma2] = mixgauss_Mstep(postmix, m, op, ip, 'cov_type', cov_type);
    if adj_mu
      mu = reshape(mu2, [O Q M]);
    end
    if adj_Sigma
      Sigma = reshape(Sigma2, [O O Q M]);
    end
  end
  if adj_term
   A = mk_stochastic([Z exp_num_visitsT]);
   term = A(:, end);
  end
  if adj_obs
    obsmat = mk_stochastic(exp_num_emit);
  end
    
  if verbose, fprintf(1, 'iteration %d, loglik = %f\n', num_iter, loglik); end
  num_iter =  num_iter + 1;
  converged = em_converged(loglik, previous_loglik, thresh);
  previous_loglik = loglik;
  LL = [LL loglik]; %#ok<AGROW>
end


%%%%%%%%%

function [loglik, exp_num_trans, exp_num_visits1, postmix, m, ip, op, ...
    exp_num_visitsT, exp_num_emit] = ...
    ess_dmhmm(prior, transmat, mixmat, mu, Sigma, data, term, obsmat, dirichlet)
% ESS_MHMM Compute the Expected Sufficient Statistics for a MOG Hidden Markov Model.
%
% Outputs:
% exp_num_trans(i,j)   = sum_l sum_{t=2}^T Pr(Q(t-1) = i, Q(t) = j| Obs(l))
% exp_num_visits1(i)   = sum_l Pr(Q(1)=i | Obs(l))
%
% Let w(i,k,t,l) = P(Q(t)=i, M(t)=k | Obs(l))
% where Obs(l) = Obs(:,:,l) = O_1 .. O_T for sequence l
% Then 
% postmix(i,k) = sum_l sum_t w(i,k,t,l) (posterior mixing weights/ responsibilities)
% m(:,i,k)   = sum_l sum_t w(i,k,t,l) * Obs(:,t,l)
% ip(i,k) = sum_l sum_t w(i,k,t,l) * Obs(:,t,l)' * Obs(:,t,l)
% op(:,:,i,k) = sum_l sum_t w(i,k,t,l) * Obs(:,t,l) * Obs(:,t,l)'

%[O T numex] = size(data);
numex = length(data);
mNdx = 1 : size(mu, 1);
dCO = length(mNdx);
Q = length(prior);
M = size(mixmat,2);
exp_num_trans = zeros(Q,Q);
exp_num_visits1 = zeros(Q,1);
exp_num_visitsT = zeros(Q, 1);
postmix = zeros(Q,M);
m = zeros(dCO, Q, M);
op = zeros(dCO, dCO, Q, M);
ip = zeros(Q, M);

mix = (M>1);

loglik = 0;

nDO = size(obsmat, 2); % number of discrete observations.
exp_num_emit = dirichlet * ones(Q, nDO);

for ex=1:numex
  %obs = data(:,:,ex);
  obs = data{ex};
  cObs = obs(mNdx, :);
  dObs = obs(end, :);
  T = size(obs,2);
  if mix
    [B, B2] = mixgauss_prob(cObs, mu, Sigma, mixmat);
    obslik = multinomial_prob(dObs, obsmat);
    B = B .* obslik;
    [~, ~, gamma,  current_loglik, xi_summed, gamma2] = ...
        fwdback(prior, transmat, B, 'obslik2', B2, 'mixmat', mixmat, 'term', term);
  else
    B = mixgauss_prob(obs, mu, Sigma);
    
    [~, ~, gamma,  current_loglik, xi_summed] = fwdback(prior, transmat, B, 'term', term);
  end    
  
  fwdback(prior, transmat, obslik);
  
  loglik = loglik +  current_loglik; 

  exp_num_trans = exp_num_trans + xi_summed; % sum(xi,3);
  exp_num_visits1 = exp_num_visits1 + gamma(:, 1);
  exp_num_visitsT = exp_num_visitsT + gamma(:, T);
  
  if mix
    postmix = postmix + sum(gamma2,3);
  else
    postmix = postmix + sum(gamma,2); 
    gamma2 = reshape(gamma, [Q 1 T]); % gamma2(i,m,t) = gamma(i,t)
  end
  for i=1:Q
    for k=1:M
      w = reshape(gamma2(i,k,:), [1 T]); % w(t) = w(i,k,t,l)
      wobs = cObs .* repmat(w, [dCO 1]); % wobs(:,t) = w(t) * obs(:,t)
      m(:,i,k) = m(:,i,k) + sum(wobs, 2); % m(:) = sum_t w(t) obs(:,t)
      op(:,:,i,k) = op(:,:,i,k) + wobs * cObs'; % op(:,:) = sum_t w(t) * obs(:,t) * obs(:,t)'
      ip(i,k) = ip(i,k) + sum(sum(wobs .* cObs, 2)); % ip = sum_t w(t) * obs(:,t)' * obs(:,t)
    end
  end
  
   % loop over whichever is shorter
  if T < nDO
    for t = 1 : T
     o = dObs(t);
     exp_num_emit(:, o) = exp_num_emit(:, o) + gamma(:, t);
    end
  else
    for o = 1 : nDO
     ndx = find(dObs == o);
     if ~isempty(ndx)
       exp_num_emit(:, o) = exp_num_emit(:, o) + sum(gamma(:, ndx), 2);
     end
    end
  end
end