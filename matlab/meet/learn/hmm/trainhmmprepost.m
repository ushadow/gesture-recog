function hmm = trainhmmprepost(Y, X, param)
%% TRAINHMMPREPPOST trains HMMs for each gesture and its pre and post-strokes.
%
% ARGS
% Y, X  - training data

ngestures = param.vocabularySize - 3;
nstages = 3;

XByClass = segmentbyclassprepost(Y, X, ngestures);

model.prior = cell(param.vocabularySize, nstages);
model.transmat = cell(param.vocabularySize, nstages);
model.mu = cell(param.vocabularySize, nstages); % d x nS x nM matrix
model.Sigma = cell(param.vocabularySize, nstages);
model.term = cell(param.vocabularySize, nstages);
model.mixmat = cell(param.vocabularySize, nstages);
model.segment = [];

if ~isempty(param.segment)
  restNdx = param.vocabularySize;
  model.segment = trainsegment(Y, X, restNdx, param.nRest, ...
                               param.segmentFeatureNdx);
  [model.prior{restNdx, 1}, model.transmat{restNdx, 1}, model.mu{restNdx, 1}, ...
        model.Sigma{restNdx, 1}, model.mixmat{restNdx, 1}, ...
        model.term{restNdx, 1}] = getrestmodel(model.segment.restMu, ...
            model.segment.restSigma, model.segment.restMixmat, param.nM);
end

for i = 1 : ngestures
  for s = 1 : nstages
    [model.prior{i, s}, model.transmat{i, s}, model.term{i, s}, ...
        model.mu{i, s}, model.Sigma{i, s}, model.mixmat{i, s}] = inithmmparam(...
        XByClass{i, s}, param.nSMap(s), param.nM, param.XcovType, s);
    [~, model.prior{i, s}, model.transmat{i, s}, model.mu{i, s}, ...
        model.Sigma{i, s}, model.mixmat{i, s}, model.term{i, s}] = ...
        mhmm_em(XByClass{i, s}, model.prior{i, s}, model.transmat{i, s}, ...
        model.mu{i, s}, model.Sigma{i, s}, ...
        model.mixmat{i, s}, 'adj_prior', 1, 'max_iter', param.maxIter, 'cov_type', ...
        param.XcovType, 'adj_Sigma', 1, 'term', model.term{i, s});
  end
end

hmm.type = 'hmm';
hmm.model = model;
end
