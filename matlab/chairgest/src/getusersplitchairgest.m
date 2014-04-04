function split = getusersplitchairgest(data, nFolds)
%
% ARGS
% data  - cell array, each cell is a user data.

nPids = numel(data);
userSplit = cell(1, nPids);

count = 0;
for i = 1 : nPids
  nSeqs = length(data{i}.Y);
  userSplit{i} = count + (1 : nSeqs);
  count = count + nSeqs;
end

split = cell(3, nFolds);

mask = floor((0 : nPids - 1) / nFolds) + 1;

for i = 1 : nFolds
  split{2, i} = cell2mat(userSplit(mask == i));
  split{1, i} = cell2mat(userSplit(mask ~= i));
end
