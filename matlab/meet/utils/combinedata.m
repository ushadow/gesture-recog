function combined = combinedata(data)
[Y, X, timestamp] = cellfun(@getfields, data, 'UniformOutput', false);
combined.userId = data{1}.userId;
combined.Y = [Y{:}];
combined.X = [X{:}];
combined.timestamp = [timestamp{:}];
combined.split = data{1}.split;
base = size(data{1}.X, 2);
for i = 2 : numel(data)
  for j = 1 : 3
    combined.split{j} = [combined.split{j}, data{i}.split{j} + base];
  end
  base = base + size(data{i}.X, 2);
end
end

function [Y, X, timestamp] = getfields(data)
Y = data.Y;
X = data.X;
timestamp = data.timestamp;
end