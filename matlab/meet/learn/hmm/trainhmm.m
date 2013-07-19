function hmm = trainhmm(Y, X, param)
% TRAINHMM trains an HMM model for every gesture class.
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

for i = 1 : param.vocabularySize
  [prior0, transmat0, term0, mu0, Sigma0] = inithmmparam(XByClass{i}, param.nS);
  [~, model.prior{i}, model.transmat{i}, model.mu{i}, model.Sigma{i}, ...
      ~, model.term{i}] = mhmm_em(XByClass{i}, prior0, transmat0, mu0, ...
      Sigma0, [], 'adj_prior', 1, 'max_iter', param.maxIter, 'cov_type', param.XcovType, ...
      'adj_Sigma', 1, 'term', term0);
end

hmm.type = 'hmm';
hmm.model = model;
end
