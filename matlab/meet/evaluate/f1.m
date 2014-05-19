function res = f1(Ytrue, Ystar, param)
%% F1 F1 score
%
% ARGS
% Ytrue  - cell array 2-by-T sequences.
% gtLabels  - groud truth labels

restLabel = param.vocabularySize;
prePostMargin = param.prePostMargin;

[res.precisionD, res.recallD, res.f1D, res.timeScore] = computestats(Ytrue, Ystar, restLabel, ...
      param.gestureType, 'D', prePostMargin);
[res.precisionS, res.recallS, res.f1S] = computestats(Ytrue, Ystar, restLabel, ...
      param.gestureType, 'S', prePostMargin);
end

function [precision, recall, f1, timeScore] = computestats(YtrueAll, ...
    YstarAll, restLabel, gestureType, type, prePostMargin)
 %
 % ARGS
 % YtrueAll   - cell array of 2-by-T sequences.
 
nTotalHit = 0;
nTotalEvents = 0;
nTotalGtEvents = 0;
totalTimeScore = 0;
for i = 1 : numel(YtrueAll)
  Ytrue = YtrueAll{i};
  Ystar = YstarAll{i};
  I = ~strcmp(gestureType(Ystar(1, :)), type) | ...
      strcmp(gestureType(Ytrue(1, :)), 'OP'); % Ignore other pose
  Ystar(1, I) = restLabel;
  
  I = ~strcmp(gestureType(Ytrue(1, :)), type);
  Ytrue(1, I) = restLabel;
  switch type
    case 'D'
      [hit, nGtEvents, nEvents, timeScore] = computeeventstats(Ytrue, Ystar, restLabel);
      totalTimeScore = totalTimeScore + timeScore;
    case 'S'
      [hit, nGtEvents, nEvents] = computeframestats(Ytrue, Ystar, restLabel, prePostMargin);
  end
  nTotalHit = nTotalHit + hit;
  nTotalEvents = nTotalEvents + nEvents;
  nTotalGtEvents = nTotalGtEvents + nGtEvents;
end

precision = nTotalHit / nTotalEvents;
recall = nTotalHit / nTotalGtEvents;
f1 = 2 * precision * recall / (precision + recall);
timeScore = totalTimeScore / nTotalHit;
end

function [hit, nGtEvents, nDetectedEvents] = computeframestats(Ytrue, ...
    Ystar, restLabel, prePostMargin)
% ground truth events
events = computegtsegments(Ytrue, restLabel);
for i = 1 : length(events)
  if i < restLabel
    runs = events{i};
    for j = 1 : size(runs, 1)
      startNdx = runs(j, 1);
      endNdx = runs(j, 2);
      % Remove the first 15 frames and last 15 frames because they may be
      % pre and post strokes
      Ytrue(1, startNdx : min(endNdx, startNdx + prePostMargin)) = restLabel;
      Ystar(1, startNdx : min(endNdx, startNdx + prePostMargin)) = restLabel;
      Ytrue(1, max(startNdx, endNdx - prePostMargin : endNdx)) = restLabel;
      Ystar(1, max(startNdx, endNdx - prePostMargin : endNdx)) = restLabel;
    end
  end
end
hit = sum(Ytrue(1, :) == Ystar(1, :) & Ystar(1, :) < restLabel);
nGtEvents = sum(Ytrue(1, :) < restLabel);
nDetectedEvents = sum(Ystar(1, :) < restLabel);
end

function [hit, nGtEvents, nDetectedEvents, timeScore] = ...
    computeeventstats(Ytrue, Ystar, restLabel)
%%
% ARGS
% restLabel   - label for the rest position which should always be the last
%     last label.
%
% RETURNS
% hit   - number of true positives

gtEvents = computegtsegments(Ytrue, restLabel);
nGtEvents = computenevents(gtEvents, restLabel);
events = contiguous(Ystar(1, :));
hit = 0;
nDetectedEvents = 0;
timeScore = 0;
for i = 1 : size(events, 1)
  label = events{i, 1};
  if label ~= restLabel
    runs = events{i, 2};
    gtRuns = gtEvents{label};
    nEvents = size(runs, 1);
    nDetectedEvents = nDetectedEvents + nEvents;
    for j = 1 : nEvents % The events for each gesture is ordered in time.
      for k = 1 : size(gtRuns, 1)
        if timeissimilar(gtRuns(k, :), runs(j, :))
          timeScore = timeScore + gtRuns(k, 2) - runs(j, 2);
          hit = hit + 1;
          gtRuns(k, :) = [];
          gtEvents{label} = gtRuns;
          break;
        end
      end
    end
  end
end
end

function nEvents = computenevents(events, restLabel)
nEvents = 0;
for i = 1 : length(events)
  if i < restLabel
    runs = events{i};
    nEvents = nEvents + size(runs, 1);
  end
end
end

function res = timeissimilar(gtRange, range)
timeDiff = (gtRange(2) - gtRange(1) + 1) / 2;
res = range(2) >= gtRange(1) && range(2) < gtRange(2) + timeDiff;
end


