function [data, totalNInvalid] = checkautoseg(data, addRest)
% ARGS
% data  - cell array or a single dataset structure.

totalNInvalid = 0;

if iscell(data)
  for i = 1 : numel(data)
    if isempty(data{i})
      continue;
    end
    [data{i}, nInvalid] = autoseg(data{i}, addRest); 
    totalNInvalid = totalNInvalid + nInvalid;
  end
else
  [data, nInvalid] = autoseg(data, addRest);
  totalNInvalid = totalNInvalid + nInvalid;
end
if (totalNInvalid > 0)
  error('Total number of invalid sessions = %d\n', totalNInvalid);
end
end

function [data, nInvalid] = autoseg(data, addRest)
nInvalid = 0;
if addRest
  data.Y = addrestlabel(data.Y, data.X, data.frame, data.param);
end
for j = 1 : numel(data.Y)
  nEvents = checknumevents(data.Y{j}, data.param.vocabularySize);
  expectedNEvent = data.nEvent{j};
  if nEvents ~= expectedNEvent
    fprintf('session = %d, number of events = %d', j, nEvents);
    display(data.file{j});
    nInvalid = nInvalid + 1;
  end
end
end

function nEvents = checknumevents(Y, vocabularySize)
I = Y(2, :) == 2;
nEvents = sum(Y(1, I) < vocabularySize);
end