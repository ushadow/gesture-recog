function [mu, Sigma, mixmat] = inithmmparamviterbi(data, nS, nM, covType)

mixmat = ones(nS, nM) / nM;

d = size(data{1}, 1);
newX = cell(nS, 1);
for i = 1 : length(data)
  X = data{i};
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