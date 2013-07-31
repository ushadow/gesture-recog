function hmm = trainhmmprepost(Y, X, param)
%% TRAINHMMPREPPOST trains HMMs for each gesture and its pre and post-strokes.
%

ngestures = param.vocabularySize - 3;
nstages = 3;

XByClass = segmentbyclassprepost(Y, X, ngestures);

model.prior = cell(param.vocabularySize, 1);
model.transmat = cell(param.vocabularySize, 1);
model.mu = cell(param.vocabularySize, 1); % d x nS x nM matrix
model.Sigma = cell(param.vocabularySize, 1);
model.term = cell(param.vocabularySize, 1);
model.mixmat = cell(param.vocabularySize, 1);

restNDX = param.vocabularySize;
[model.prior{restNDX}, model.transmat{restNDX}, model.mu{restNDX}, ...
      model.Sigma{restNDX}, model.mixmat{restNDX}, ...
      model.term{restNDX}] = trainrestmodel(XByClass{restNDX}, param.nM);

for i = 1 : ngestures
  prior = cell(1, nstages);
  transmat = cell(1, nstages);
  term = cell(1, nstages);
  mu = cell(1, nstages);
  Sigma = cell(1, nstages);
  mixmat = cell(1, nstages);
  for s = 1 : nstages
    [prior{s}, transmat{s}, term{s}, mu{s}, Sigma{s}, mixmat{s}] = inithmmparam(...
        XByClass{i, s}, param.nSMap(s), param.nM, param.XcovType, s);
    [~, prior{s}, transmat{s}, mu{s}, Sigma{s}, mixmat{s}, term{s}] = ...
      mhmm_em(XByClass{i, s}, prior{s}, transmat{s}, mu{s}, Sigma{s}, ...
      mixmat{s}, 'adj_prior', 1, 'max_iter', param.maxIter, 'cov_type', ...
      param.XcovType, 'adj_Sigma', 1, 'term', term{s});
  end
  model.prior{i} = prior;
  model.transmat{i} = transmat;
  model.mu{i} = mu;
  model.Sigma{i} = Sigma;
  model.mixmat{i} = mixmat;
  model.term{i} = term;
end

model.segment = trainsegment(Y, X, param.vocabularySize);
hmm.type = 'hmm';
hmm.model = model;
end
