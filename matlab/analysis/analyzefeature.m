function analyzefeature(data, segFrameId)
distAll = [];
frameidAll = [];
for i = 1 : length(data)
  seq = data{i};
  frameid = segFrameId{i}';
  nframe = length(seq);
  dist = zeros(1, nframe);
  for j = 2 : nframe
    dist(j) = norm(seq{4, j}{1} - seq{4, j - 1}{1}); 
  end
  distAll = [distAll dist];
  frameidAll = [frameidAll frameid];
end

figure(1);
plot(frameidAll, distAll, 'b+-');
figure(2);
boxplot(dist);
end