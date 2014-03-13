function hmm = trainhmm(Y, X, param)
%% TRAINHMM trains an HMM model for every gesture class. Does not consider
% pre and post strokes.
%
% ARGS
% Y, X  - training labels and features.

% Cell array of sequences for each class.
XByClass = segmentbyclass(Y, X, param);

for i = 1 : param.vocabularySize
  if ~isempty(XByClass{i})
    d = size(XByClass{i}{1}, 1);
    break;
  end
end

model.prior = cell(param.vocabularySize, 1);
model.transmat = cell(param.vocabularySize, 1);
model.mu = cell(param.vocabularySize, 1); % d x nS x nM matrix
model.Sigma = cell(param.vocabularySize, 1);
model.term = cell(param.vocabularySize, 1);
model.mixmat = cell(param.vocabularySize, 1);
model.obsmat = cell(param.vocabularySize, 1);
        
for i = 1 : param.vocabularySize
  nS = param.nS(i);
  if ~isempty(XByClass{i})
    rep = param.repeat(i);
    
    if nS > 1
      [prior0, transmat0, term0] = makeembedtrans(nS, rep);
      [~, ~, mu0, Sigma0, mixmat0] = trainviterbi(XByClass{i}, ...
          prior0, transmat0, param.nM(1), 'term', term0, 'cov_type', param.XcovType, ...
          'max_iter', 2, 'feature_ndx', param.featureNdx);
      [prior0, transmat0, term0] = makebakistrans(nS, rep);
      if param.hasDiscrete
        obsmat0 = initobsmat(nS, param.nHandPoseType);
        [~, model.prior{i}, model.transmat{i}, model.mu{i}, model.Sigma{i}, ...
            model.mixmat{i}, model.term{i}, model.obsmat{i}] = dmhmmem(XByClass{i}, prior0, ...
            transmat0, mu0, Sigma0, mixmat0, obsmat0, ...
            'max_iter', param.maxIter, 'cov_type', param.XcovType, ...
            'term', term0);
      else
        [~, model.prior{i}, model.transmat{i}, model.mu{i}, model.Sigma{i}, ...
            model.mixmat{i}, model.term{i}] = mhmm_em(XByClass{i}, prior0, ...
            transmat0, mu0, Sigma0, mixmat0, 'max_iter', param.maxIter, ...
            'cov_type', param.XcovType, 'term', term0);
      end
    else
      [model.prior{i}, model.transmat{i}, model.mu{i}, ...
          model.Sigma{i}, model.mixmat{i}, ...
          model.term{i}] = makesimplehmmmodel(XByClass{i}, ...
          param.kinectSampleRate, param.nM, param.XcovType, param.featureNdx);
      if param.hasDiscrete
        model.obsmat{i} = singledhmm(XByClass{i}, param.nHandPoseType);
      end
    end
  else
    nM = param.nM(2);
    model.prior{i} = zeros(nS, 1);
    model.transmat{i} = zeros(nS, nS);
    model.mu{i} = zeros(d, nS, nM);
    model.Sigma{i} = repmat(eye(d, d), 1, 1, nS, nM);
    model.mixmat{i} = zeros(nS, nM);
    model.term{i} = zeros(nS, 1);
  end
end

hmm.type = 'hmm';
hmm.model = combinetoonehmm(model.prior, model.transmat, model.term, ...
    model.mu, model.Sigma, model.mixmat, model.obsmat, param);
%hmm.model = trainembedded(X, hmm.model, param);
end

function path = align(X, mu, Sigma, mixmat, prior, transmat, term) %#ok<DEFNU>
for i = 1 : numel(X)
  ev = X{i};
  obslik = mixgauss_prob(ev, mu, Sigma, mixmat);
  path = viterbi_path(prior, transmat, obslik, term);
end
end

function model = trainembedded(X, model, param)
  [~, model.prior, model.transmat, model.mu, model.Sigma, ...
            model.mixmat, model.term] = mhmm_em(X,model.prior, ...
            model.transmat, model.mu, model.Sigma, model.mixmat, 'max_iter', 1, ...
            'cov_type', param.XcovType, 'term', model.term);
end