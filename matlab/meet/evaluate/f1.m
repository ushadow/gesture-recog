function res = f1(Ytrue, Ystar, param)
%% LEVENEVENT event based Levenshtein distance
%
% ARGS
% labels  - estimated labels
% gtLabels  - groud truth labels

restLabel = param.vocabularySize;

nTotalHit = 0;
nTotalEvents = 0;
nTotalGtEvents = 0;
for i = 1 : numel(Ytrue)
  [hit, nGtEvents, nEvents] = computediscretestats(Ytrue{i}, Ystar{i}, restLabel, ...
      param.gestureType);
  nTotalHit = nTotalHit + hit;
  nTotalEvents = nTotalEvents + nEvents;
  nTotalGtEvents = nTotalGtEvents + nGtEvents;
end

res.precisionD = nTotalHit / nTotalEvents;
res.recallD = nTotalHit / nTotalGtEvents;
res.f1D = 2 * res.precisionD * res.recallD / (res.precisionD + res.recallD);
end

function [hit, nGtEvents, nTotalEvents] = computediscretestats(Ytrue, ...
  Ystar, restLabel, gestureType)
I = ~strcmp(gestureType(Ytrue(1, :)), 'D');
Ytrue(1, I) = restLabel;

I = ~strcmp(gestureType(Ystar(1, :)), 'D');
Ystar(1, I) = restLabel;
[hit, nGtEvents, nTotalEvents] = computestats(Ytrue, Ystar, restLabel);
end

function [hit, nGtEvents, nTotalEvents] = computestats(Ytrue, Ystar, ...
    restLabel)
gtEvents = contiguous(Ytrue(1, :));
nGtEvents = computenevents(gtEvents, restLabel);
gtEventsMap = containers.Map(gtEvents(:, 1), gtEvents(:, 2));
events = contiguous(Ystar(1, :));
hit = 0;
nTotalEvents = 0;
for i = 1 : size(events, 1)
  label = events{i, 1};
  if label ~= restLabel
    runs = events{i, 2};
    if isKey(gtEventsMap, label)
      gtRuns = gtEventsMap(label);
      nEvents = size(runs, 1);
      nTotalEvents = nTotalEvents + nEvents;
      for j = 1 : nEvents
        for k = 1 : size(gtRuns, 1)
          if timeissimilar(gtRuns(k, :), runs(j, :))
            hit = hit + 1;
            gtRuns(k, :) = [];
            gtEventsMap(label) = gtRuns;
            break;
          end
        end
      end
    end
  end
end
end

function nEvents = computenevents(events, restLabel)
nEvents = 0;
for i = 1 : size(events, 1)
  label = events{i, 1};
  if label ~= restLabel
    runs = events{i, 2};
    nEvents = nEvents + size(runs, 1);
  end
end
end

function res = timeissimilar(gtRange, range)
timeDiff = (gtRange(2) - gtRange(1) + 1) / 2;
res = range(2) >= gtRange(1) && range(2) < gtRange(2) + timeDiff;
end
