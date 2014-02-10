function [pred, prob, path, seg, stat] = testhmm(~, X, ~, hmm, param)

group = {'Tr', 'Va'};
hmm = hmm.model;
prob = [];
seg = [];

for i = 1 : length(group)
  dataGroup = group{i};
  if isfield(X, dataGroup)
    [pred.(dataGroup), path.(dataGroup), stat.(dataGroup)] = ...
        testdatagroup(X.(dataGroup), hmm, param);
  end
end
end

function [pred, path, stat] = testdatagroup(X, hmm, param)
nseqs = length(X);
pred = cell(1, nseqs);
path = cell(1, nseqs);
labelMap = hmm.labelMap;
stageMap = hmm.stageMap;
restLabel = param.vocabularySize;
minGamma = 1;
for i = 1 : nseqs
  ev = X{i};
  obslik = mixgauss_prob(ev, hmm.mu, hmm.Sigma, hmm.mixmat);
  switch param.inferMethod 
    case 'viterbi'
      path{i} = viterbi_path(hmm.prior, hmm.transmat, obslik, hmm.term);
    case 'fixed-lag-smoothing'
      [path{i}, stat] = fwdbackonline(hmm.prior, hmm.transmat, obslik, ...
          'lag', param.L);
      minGamma = min(minGamma, stat.minGamma);
  end
  pred{i} = computenucleuslabel(path{i}, labelMap, stageMap, restLabel);
end
stat.minGamma = minGamma;
end

function pred = computenucleuslabel(path, labelMap, stageMap, restLabel)
label = labelMap(path);
stage = stageMap(path);
n = size(label, 2);
pred = ones(1, n) * restLabel;
startNdx = 0;
for i = 2 : n
  currentStage = stage{i};
  if path(i) ~= path(i - 1)
    switch currentStage
      case {'PreStroke', 'Gesture'}
        startNdx = i;
      case 'PostStroke'
        if startNdx ~= 0
          pred(startNdx : i) = label(startNdx);
          startNdx = 0;
        end
    end
    if path(i) == restLabel && startNdx ~= 0
      pred(startNdx : i - 1) = label(startNdx);
    end
  elseif i == n && startNdx ~= 0
    pred(startNdx : i - 1) = label(startNdx);
  end
end
end