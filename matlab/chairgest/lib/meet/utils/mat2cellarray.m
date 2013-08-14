function cellArray = mat2cellarray(mat, cellArray)
% MAT2CELLARRAY converts matrix to cell array.

nseq = length(cellArray);
startNDX = 1;
for i = 1 : nseq
  old = cellArray{i};
  endNDX = startNDX + size(old, 2) - 1;
  cellArray{i} = mat(:, startNDX : endNDX);
  startNDX = endNDX + 1;
end
end