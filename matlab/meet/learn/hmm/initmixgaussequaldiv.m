function [mu, Sigma, mixmat] = initmixgaussequaldiv(data, nS, nM, covType, featureNdx)

mixmat = ones(nS, nM) / nM;

d = length(featureNdx);
newX = cell(nS, 1);
for i = 1 : length(data)
  X = data{i}(featureNdx, :);
  m = size(X, 2);
  segLen = floor(m / nS);
  startNdx = 1;
  for j = 1 : nS
    endNdx = startNdx + segLen - 1;
    newX{j} = [newX{j} X(:, startNdx : endNdx)];
    startNdx = endNdx + 1;
  end
end

mu = zeros(d, nS, nM);
Sigma = zeros(d, d, nS, nM);
for i = 1 : nS
  [mu(:, i, :), Sigma(:, :, i, :)] = mixgauss_init(nM, newX{i}, covType);
end
end