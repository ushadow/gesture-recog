function combined = combinedata(data)
% data - cell array of user data.

[Y, X, frame, file] = cellfun(@getfields, data, 'UniformOutput', false);
combined.Y = [Y{:}];
combined.X = [X{:}];
combined.frame = [frame{:}];
combined.file = [file{:}];
combined.param = data{1}.param;
combined.split = data{1}.split;
base = size(data{1}.X, 2);
for i = 2 : numel(data)
  for j = 1 : 3
    combined.split{j} = [combined.split{j}, data{i}.split{j} + base];
  end
  base = base + size(data{i}.X, 2);
end
end

function [Y, X, frame, file] = getfields(data)
Y = data.Y;
X = data.X;
frame = data.frame;
file = data.file;
end