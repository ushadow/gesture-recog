function clusters = clusterhand(features, data)
maxclust = 3;
T = kmeans(features', maxclust);

clusters = cell(1, maxclust);
for i = 1 : maxclust
  clusters{i} = data(:, T == i);
end
end