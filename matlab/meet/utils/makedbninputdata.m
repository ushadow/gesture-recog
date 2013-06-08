function data = makedbninputdata(Y, X, ahmmParam)
% CREATEINPUTDATA combines the label and feature together.
%
% Args:
% - Y: cell array of label data.
% - X: cell array of feature data.
data = cell(1, size(Y, 2));
ss = ahmmParam.ss;
for i = 1 : length(data)
  [nX, T] = size(X{i});
  data{i} = cell(ss, T);
  if any(ahmmParam.onodes == ahmmParam.G1)
    data{i}(ahmmParam.G1, :) = num2cell(Y{i}(1, :));
  end
  if any(ahmmParam.onodes == ahmmParam.F1)
    data{i}(ahmmParam.F1, :) = num2cell(Y{i}(2, :));
  end
  
  % Breaks up X{i} matrix into to a cell array. Each cell is nX * 1 vector.
  data{i}(ahmmParam.X1, :) = mat2cell(X{i}, nX, ones(1, T));
end

if any(ahmmParam.onodes == ahmmParam.G1)
  assert(all(size(data{end}{ahmmParam.G1, end}) == size(Y{end}(1, end))));
else
  assert(isempty(data{end}{ahmmParam.G1, end}));
end
assert(isempty(data{end}{ahmmParam.S1, end}));

if any(ahmmParam.onodes == ahmmParam.F1)
  assert(all(size(data{end}{ahmmParam.F1, end}) == size(Y{end}(2, end))));
else
  assert(isempty(data{end}{ahmmParam.F1, end}));
end
end