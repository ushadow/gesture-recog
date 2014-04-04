function newClusters = mergeclusters(clusters, k)
assert(numel(clusters) > k);
newClusters = cell(k, 1);
n = cellfun(@(x) length(x), clusters);
[~, I] = sort(n, 1, 'descend');
newClusters(1 : k - 1) = clusters(I(1 : k -1));
newClusters{k} = cat(2, clusters{I(k : end)});

for i = 1 : length(newClusters)
  assert(length(newClusters{i}) >= 6, 'Cluster size is smaller than 6');
end
end