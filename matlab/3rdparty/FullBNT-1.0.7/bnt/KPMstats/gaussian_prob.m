function p = gaussian_prob(x, m, C, use_log, isDiag)
% GAUSSIAN_PROB Evaluate a multivariate Gaussian density.
% p = gaussian_prob(X, m, C)
% p(i) = N(X(:,i), m, C) where C = covariance matrix and each COLUMN of x is a datavector

% p = gaussian_prob(X, m, C, 1) returns log N(X(:,i), m, C) (to prevents underflow).
%
% If X has size dxN, then p has size Nx1, where N = number of examples

if nargin < 4, use_log = 0; end
if nargin < 5, isDiag = 0; end

if length(m)==1 % scalar
  x = x(:)';
end
[d, ~] = size(x);
%assert(length(m)==d); % slow
m = m(:);

if isDiag 
  detC = prod(diag(C));
else
  detC = det(C);
end

denom = (2 * pi)^( d / 2) * sqrt(abs(detC));

% (x - m)'
centeredXT = bsxfun(@minus, x, m)'; 
if isDiag
  mahal = sum(bsxfun(@(x, y) x ./ y, centeredXT, diag(C)') .* centeredXT, 2);
else
  mahal = sum((centeredXT / C) .* centeredXT, 2);   % Chris Bregler's trick
end

if any(mahal<0)
  warning('mahal < 0 => C is not psd')
end
if use_log
  p = -0.5 * mahal - log(denom);
else
  p = exp(-0.5 * mahal) / (denom + eps);
end
