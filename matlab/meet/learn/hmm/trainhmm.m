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

nHmmMixture = param.nHmmMixture;
model.prior = cell(nHmmMixture, param.vocabularySize);
model.transmat = cell(nHmmMixture, param.vocabularySize);
model.mu = cell(nHmmMixture, param.vocabularySize); % d x nS x nM matrix
model.Sigma = cell(nHmmMixture, param.vocabularySize);
model.term = cell(nHmmMixture, param.vocabularySize);
model.mixmat = cell(nHmmMixture, param.vocabularySize);
model.obsmat = cell(nHmmMixture, param.vocabularySize);
        
for i = 1 : param.vocabularySize
  nS = param.nS(i);
  if ~isempty(XByClass{1, i})
    rep = param.repeat(i);
    
    if nS > 1
      for j = 1 : nHmmMixture 
        [prior0, transmat0, term0] = makeembedtrans(nS, rep);
        [~, ~, mu0, Sigma0, mixmat0] = trainviterbi(XByClass{j, i}, ...
            prior0, transmat0, param.nM(1), 'term', term0, 'cov_type', param.XcovType, ...
            'max_iter', 2, 'feature_ndx', param.featureNdx);
        [prior0, transmat0, term0] = makebakistrans(nS, rep);
        data = XByClass{j, i};
        if param.hasDiscrete
          data = cellfun(@(x) x(param.featureNdx, :), data, 'UniformOutput', false);
        end 
        [~, model.prior{j, i}, model.transmat{j, i}, model.mu{j, i}, model.Sigma{j, i}, ...
            model.mixmat{j, i}, model.term{j, i}] = mhmm_em(data, prior0, ...
            transmat0, mu0, Sigma0, mixmat0, 'max_iter', param.maxIter, ...
            'cov_type', param.XcovType, 'term', term0);
      end
    else
      [model.prior{1, i}, model.transmat{1, i}, model.mu{1, i}, ...
          model.Sigma{1, i}, model.mixmat{1, i}, ...
          model.term{1, i}] = makesimplehmmmodel(XByClass{1, i}, ...
          param.kinectSampleRate, param.nM, param.XcovType, param.featureNdx);
      if param.hasDiscrete
        model.obsmat{1, i} = singledhmm(XByClass{1, i}, param.nHandPoseType);
      end
    end
  else
    nM = param.nM(2);
    model.prior{1, i} = zeros(nS, 1);
    model.transmat{1, i} = zeros(nS, nS);
    model.mu{1, i} = zeros(d, nS, nM);
    model.Sigma{1, i} = repmat(eye(d, d), 1, 1, nS, nM);
    model.mixmat{1, i} = zeros(nS, nM);
    model.term{1, i} = zeros(nS, 1);
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

function model = trainembedded(X, model, param) %#ok<DEFNU>
  [~, model.prior, model.transmat, model.mu, model.Sigma, ...
            model.mixmat, model.term] = mhmm_em(X,model.prior, ...
            model.transmat, model.mu, model.Sigma, model.mixmat, 'max_iter', 1, ...
            'cov_type', param.XcovType, 'term', model.term);
end