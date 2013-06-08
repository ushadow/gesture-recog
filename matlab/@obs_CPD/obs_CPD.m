function CPD = obs_CPD(bnet, self, hand, hd_mu, hd_sigma, varargin)
% OBS_CPD Customized observation CPD.
%
% CPD = obs_CPD(bnet, self, hand, hd_mu, hd_sigma, varargin)
% hand(:, i) is the initial hand template for S = i.
%
% Optional arguments:
% mean: mu(:, i) is the mean continuous features given S = i 
%       [ randn(X, S) ]
% cov: Sigma(:, :, i) is the covariance of the continous features given 
%      S = i [ repmat(100 * eye(X, X), [1 1 S] ]
% tied_cov: if 1, we constrain Sigma(:, :, i) to be the same for all i [0].

if nargin == 0
  % This occurs if we are trying to load an object from a file.
  CPD = init_fields;
  clamp = 0;
  CPD = class(CPD, 'obs_CPD', generic_CPD(clamp));
  return;
elseif isa(bnet, 'obs_CPD')
  % This might occor if we are copying an object.
  CPD = bnet;
  return;
end
CPD = init_fields;

CPD = class(CPD, 'obs_CPD', generic_CPD(0));

args = varargin;
ns = bnet.node_sizes;
ps = parents(bnet.dag, self);
dps = myintersect(ps, bnet.dnodes);
fam_sz = ns([ps self]);

CPD.self = self;
CPD.sizes = fam_sz;

% Figure out which of the parents are discrete and how big they are.
CPD.dps = find_equiv_posns(dps, ps);
ss = fam_sz(end);
psz = fam_sz(1 : end - 1);
dpsz = prod(psz(CPD.dps));

% Sets default params
CPD.mean = randn(ss, dpsz);
CPD.cov = 100 * repmat(eye(ss), [1 1 dpsz]);
CPD.cov_type = 'full';
CPD.tied_cov = 0;
CPD.clamped_mean = 0;
CPD.clamped_cov = 0;
CPD.cov_prior_weight = 0.01;
CPD.hand = hand;
CPD.hd_mu = hd_mu;
CPD.hd_sigma = hd_sigma;

nargs = length(args);
if nargs > 0 
  CPD = set_fields(CPD, args{:});
end

CPD.mean = myreshape(CPD.mean, [ss ns(dps)]);
CPD.cov = myreshape(CPD.cov, [ss ss ns(dps)]);

% Learning
% Expected sufficient statistics.
CPD.Wsum = zeros(dpsz, 1);
CPD.WY1sum = zeros(ss, dpsz);
CPD.WY1Y1sum = zeros(ss, ss, dpsz);
n = length(hand); % size of the hand image.
CPD.WY2sum = zeros(n, dpsz);

% For BIC
CPD.nsamples = 0;
switch CPD.cov_type
  case 'full',
    ncov_params = ss * (ss + 1) / 2;
  case 'diag',
    ncov_params = ss;
  otherwise
    error(['unrecognized cov_type ' cov_type]);
end

if CPD.tied_cov
  CPD.nparams = ss * dpsz + ncov_params + dpsz;
else
  CPD.nparams = ss * dpsz + dpsz * ncov_params + dpsz;
end

clamped = CPD.clamped_mean & CPD.clamped_cov;
CPD = set_clamped(CPD, clamped);

end

function CPD = init_fields
CPD.self = [];
CPD.sizes = [];
CPD.dps = [];
CPD.mean = [];
CPD.cov = [];
CPD.clamped_mean = [];
CPD.clamped_cov = [];
CPD.cov_type = [];
CPD.tied_cov = [];
CPD.cov_prior_weight = [];
CPD.hand = [];
CPD.Wsum = [];
CPD.WY1sum = [];
CPD.WY1Y1sum = [];
CPD.WY2sum = [];
CPD.nsamples = [];
CPD.hd_mu = [];
CPD.hd_sigma = [];
CPD.nparams = [];
end