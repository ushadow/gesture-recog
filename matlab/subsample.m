function data = subsample(data, factor)
data.Y = subsampleset(data.Y, factor);
data.X = subsampleset(data.X, factor);
end

function data = subsampleset(data, factor)
for i = 1 : numel(data)
  data{i} = subsample1(data{i}, factor);
end
end

function newData = subsample1(data, factor)
[nrow, ncol] = size(data);
newcol = floor(ncol / factor);
newData = cell(nrow, newcol);
for i = 1 : newcol
  newData(:, i) = data(:, i * factor);
end
end