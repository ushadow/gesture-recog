function m = adddefaultmat(m, default, nDims, lastDimSize)
%%
% ARGS
% m   - cell array.
% nDims   - number of dimensions in the output matrices.

for i = 1 : numel(m)
  s = size(m{i});
  if length(s) < nDims
    s = [s ones(1, nDims - length(s))]; %#ok<AGROW>
  end
  if s(end) < lastDimSize
    oldLastDim = s(end);
    s(end) = lastDimSize;
    rep = ones(1, length(s));
    rep(end - 1 : end) = s(end - 1 : end);
    newMu = repmat(default, rep);
    ndx = cell(1, nDims);
    for j = 1 : length(ndx) - 1
      ndx{j} = 1 : s(j);
    end
    ndx{length(s)} = 1 : oldLastDim;
    newMu(ndx{:}) = m{i};
    m{i} = newMu;
  end
end
end