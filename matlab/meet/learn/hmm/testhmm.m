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
  pred{i} = computenucleuslabel(path{i}, labelMap, stageMap, param.gestureType, ...
                                restLabel);
end
stat.minGamma = minGamma;
end

function pred = computenucleuslabel(path, labelMap, stageMap, gestureType,...
                                    restLabel)
label = labelMap(path);
stage = stageMap(path);
n = size(label, 2);
pred = ones(1, n) * restLabel;
prevStage = '';
prevEvent = '';
segLen = 1;
for i = 1 : n
  currentStage = stage{i};
  nucleus = label(i);
  gestureEvent = '';
  if ~strcmp(prevStage, currentStage)
    switch currentStage
      case 'PreStroke'
        gestureEvent = 'StartPreStroke';
      case 'Gesture'
        gestureEvent = 'StartGesture';
      case 'Rest'
        if strcmp(prevEvent, 'StartGesture')
          nucleus = prevGesture;
          startNdx = max(1, i - segLen);
          pred(startNdx : i) = nucleus;
        end
      case 'PostStroke'
        if strcmp(prevEvent, 'StartGesture')
          gestureEvent = 'StartPostStroke';
          nucleus = prevGesture;
          startNdx = max(1, i - segLen);
          pred(startNdx : i) = nucleus;
        end
    end
  end
  if strcmp(currentStage, 'Gesture') && strcmp(gestureType(nucleus), 'S') 
     pred(i) = nucleus;
  end
  prevStage = currentStage;
  prevGesture = nucleus;
  if ~isempty(gestureEvent) 
    prevEvent = gestureEvent;
  end
end
end