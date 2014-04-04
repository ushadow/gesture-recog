function seg = checkautoseg(data, addRest)
% ARGS
% data

count = 0;
for i = 1 : numel(data)
  if isempty(data{i})
    continue;
  end
  if addRest
    [data{i}.Y, data{i}.X, data{i}.frame] = addrestlabel(data{i}.Y, ...
      data{i}.X, data{i}.frame, data{i}.param);
  end
  data1 = data{i};
  for j = 1 : numel(data1.Y)
    nEvents = checknumevents(data1.Y{j}, data1.param.vocabularySize);
    if nEvents ~= 21
      fprintf('session = %d, number of events = %d', j, nEvents);
      display(data1.file{j});
      count = count + 1;
    end
  end
end
fprintf('total count = %d\n', count);
seg = data;
end

function nEvents = checknumevents(Y, vocabularySize)
I = Y(2, :) == 2;
nEvents = sum(Y(1, I) < vocabularySize);
end