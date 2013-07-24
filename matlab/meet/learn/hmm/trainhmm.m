function hmm = trainhmm(Y, X, param)
%% TRAINHMM trains an HMM model for every gesture class.
%
% ARGS
% Y, X  - training labels and features.

% Cell array of sequences for each class.
XByClass = segmentbyclass(Y, X, param.vocabularySize);

model.prior = cell(param.vocabularySize, 1);
model.transmat = cell(param.vocabularySize, 1);
model.mu = cell(param.vocabularySize, 1);
model.Sigma = cell(param.vocabularySize, 1);
model.term = cell(param.vocabularySize, 1);
model.mixmat = cell(param.vocabularySize, 1);

for i = 1 : param.vocabularySize - 1
  [prior0, transmat0, term0, mu0, Sigma0, mixmat0] = inithmmparam(...
      XByClass{i}, param.nHiddenStatePerGesture, param.M, param.XcovType);
  [~, model.prior{i}, model.transmat{i}, model.mu{i}, model.Sigma{i}, ...
      model.mixmat{i}, model.term{i}] = mhmm_em(XByClass{i}, prior0, ...
      transmat0, mu0, Sigma0, mixmat0, 'adj_prior', 1, ...
      'max_iter', param.maxIter, 'cov_type', param.XcovType, ...
      'adj_Sigma', 1, 'term', term0);
end

i = param.vocabularySize;
[model.prior{i}, model.transmat{i}, model.mu{i}, model.Sigma{i}, ...
      model.mixmat{i}, model.term{i}] = trainrest(XByClass{i});
    
hmm.type = 'hmm';
hmm.model = model;
end

function [prior, transmat, mu, Sigma, mixmat, term] = trainrest(X)
X = cell2mat(X);

prior = 1;
transmat = 1;
mu = mean(X, 2);
Sigma = diag(std(X, 0, 2));
mixmat = 1;
term = 0.5;
end