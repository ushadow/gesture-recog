function [prior, transmat, term, mu, Sigma] = inithmmparam(data, nS)
%
% ARGS
% data  - cell arrays of observation sequence. data{i}(:, j) is the jth 
%         observation in ith sequence.
% nS    - number of hidden states S.

% Uniform initialization.
prior = ones(nS, 1) / nS;
transmat = ones(nS) / nS;
term = ones(nS, 1) / nS;

% switch type
%   case 'gesture'
%     % Bakis model for state transition.    
%     prior(1 : 2) = 1 / 2;    
%     for i = 1 : nS
%       transmat(i, mod(i - 1 : i + 1, nS) + 1) = 1 / 3;
%     end
%     term(end - 1 : end) = 1 / 2;    
%   case 'rest'
%     prior(:) = 1 / nS;
%     NDX = logical(eye(size(transmat)));
%     selfProb = 0.9;
%     delta = 0.01;
%     transmat(NDX) = selfProb;
%     transmat(~NDX) = (1 - selfProb - delta) / (nS - 1);
%     term(:) = 0.01; 
% end

[mu, assign] = initmean(data, nS);

ndxSum = zeros(nS, 1);
for i = 1 : nS
  ndxSum(i) = sum(find(assign == i));
end
[~, I] = sort(ndxSum);
mu = mu(:, I);

nX = size(mu, 1);
Sigma = repmat(100 * eye(nX, nX), [1 1 nS]);
end