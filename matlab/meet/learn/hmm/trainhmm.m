function hmm = trainhmm(Y, X, param)
%% TRAINHMM trains an HMM model for every gesture class. Does not consider
% pre and post strokes.
%
% ARGS
% Y, X  - training labels and features.

ngestures = param.vocabularySize - 1;

% Cell array of sequences for each class.
XByClass = segmentbyclass(Y, X, param.vocabularySize, param.combineprepost);

model.prior = cell(param.vocabularySize, 1);
model.transmat = cell(param.vocabularySize, 1);
model.mu = cell(param.vocabularySize, 1); % d x nS x nM matrix
model.Sigma = cell(param.vocabularySize, 1);
model.term = cell(param.vocabularySize, 1);
model.mixmat = cell(param.vocabularySize, 1);

restNDX = param.vocabularySize;
model.segment = trainsegment(Y, X, restNDX, param.nRest);
[model.prior{restNDX}, model.transmat{restNDX}, model.mu{restNDX}, ...
      model.Sigma{restNDX}, model.mixmat{restNDX}, ...
      model.term{restNDX}] = getrestmodel(model.segment.restMu, ...
      model.segment.restSigma, model.segment.restMixmat, param.nM);
        
for i = 1 : ngestures
  if ~isempty(XByClass{i})
    [prior0, transmat0, term0, mu0, Sigma0, mixmat0] = inithmmparam(...
        XByClass{i}, param.nS, param.nM, param.XcovType, 2);
    [~, model.prior{i}, model.transmat{i}, model.mu{i}, model.Sigma{i}, ...
        model.mixmat{i}, model.term{i}] = mhmm_em(XByClass{i}, prior0, ...
        transmat0, mu0, Sigma0, mixmat0, 'adj_prior', 1, ...
        'max_iter', param.maxIter, 'cov_type', param.XcovType, ...
        'adj_Sigma', 1, 'term', term0);
  end
end

hmm.type = 'hmm';
hmm.model = combinetoonehmm(model.prior, model.transmat, model.term, ...
    model.mu, model.Sigma, model.mixmat);
end