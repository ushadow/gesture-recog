function dist = computehausdorff(data)
nframe = size(data, 2);

dist = zeros(1, nframe);
reference = image2points(data(:, 1));
for i = 2 : nframe 
  pointCloud = image2points(data(:, i)); 
  dist(i) = hausdorfflikedist(reference, pointCloud);
end
end