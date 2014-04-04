function split = getusersplit(data)

nPids = numel(data);

ndx = 1 : nPids * 4;
ndx = reshape(ndx, 4, nPids);
split = cell(3, nPids);
for i = 1 : nPids
  split{2, i} = ndx(3 : 4, i)';
  trainNdx = ndx(1 : 2, :);
  trainNdx(:, i) = [];
  split{1, i} = trainNdx(:)';
end
end