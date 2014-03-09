function obsmat = singledhmm(data, nHandPoseType)
data = cell2mat(data);
data = data(end, :);
freq = tabulate(data);
obsmat = zeros(1, nHandPoseType);
for i = 1 : size(freq, 1)
  obsmat(freq(i, 1)) = freq(i, 3) / 100;
end
end