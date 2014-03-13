function d = distdtw(x, c)
%
% ARGS
% x   - cell array of D-by-M matrices
% c   - cell array of D-by-N matrices
%
% RETURN
% d   - M-by-N matrix

nData = numel(x);
 
nCenter = numel(c);

d = zeros(nData, nCenter);
for i = 1 : nData
  for j = 1 : nCenter
    frameDist = dist2(x{i}', c{j}');
    d(i, j) = dtw_scores(frameDist);
  end
end

s = 1 ./ (d + eps);
end