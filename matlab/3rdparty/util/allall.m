function res = allall(X)
ndim = ndims(X);
res = X;
for d = 1 : ndim
  res = all(res, d);
end
