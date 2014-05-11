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
nSeq = length(X);
pred = cell(1, nSeq);
path = cell(1, nSeq);
stat = cell(1, nSeq);
labelMap = hmm.labelMap;
stageMap = hmm.stageMap;
restLabel = param.vocabularySize;
featureNdx = param.featureNdx;
for i = 1 : nSeq
  ev = X{i};
  obslik = mixgauss_prob(ev(featureNdx, :), hmm.mu, hmm.Sigma, hmm.mixmat);
  switch param.inferMethod 
    case 'viterbi'
      path{i} = viterbi_path(hmm.prior, hmm.transmat, obslik, hmm.term);
    case 'fixed-lag-smoothing'
      [path{i}, stat{i}] = fwdbackonline(hmm.prior, hmm.transmat, obslik, ...
          'lag', param.L);
  end
  pred{i} = computenucleuslabel(path{i}, labelMap, stageMap, param.gestureType, ...
                                restLabel);
end
end

function pred = computenucleuslabel(path, labelMap, stageMap, gestureType,...
                                    restLabel)
label = labelMap(path); % Gesture label indices
stage = stageMap(path);
n = size(label, 2);
pred = ones(1, n) * restLabel;
prevStage = '';
prevEvent = '';
prevGesture = 0;
segLen = 1;
for i = 1 : n
  currentStage = stage{i};
  nucleus = label(i);
  gestureEvent = '';
  % When gesture stage changes.
  if ~strcmp(prevStage, currentStage) 
    switch currentStage
      case 'PreStroke'
        if strcmp(prevEvent, 'StartGesture') && i - startGestureTime > 5
          startNdx = max(1, i - segLen);
          pred(startNdx : i) = prevGesture;
        end
        gestureEvent = 'StartPreStroke';
        startGestureTime = i;
      case 'Gesture'
        gestureEvent = 'StartGesture';
        startGestureTime = i;
      case 'Rest'
        if strcmp(prevEvent, 'StartGesture') && i - startGestureTime > 5
          startNdx = max(1, i - segLen);
          pred(startNdx : i) = prevGesture;
        end
      case 'PostStroke'
        if strcmp(prevEvent, 'StartGesture')
          gestureEvent = 'StartPostStroke';
          nucleus = prevGesture;
          if i - startGestureTime > 5
            startNdx = max(1, i - segLen);
            pred(startNdx : i) = nucleus;
          end
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