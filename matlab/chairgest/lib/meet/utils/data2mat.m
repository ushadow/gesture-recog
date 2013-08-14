function mat = data2mat(data)
% DATA2MAT combines vectors in each cell into columns of a matrix.
%
% Args:
% - data: cell array of cell arrays.

for i = 1 : length(data)
  data{i} = cell2mat(data{i});
end
mat = cell2mat(data);
end