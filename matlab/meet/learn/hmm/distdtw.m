function d = distdtw(x)
% DISTDTW pairwise distance between sequence data in x using dynamic time
%   warping.
%
% ARGS
% x   - cell array of D-by-M matrices
%
% RETURN
% d   - M-by-M matrix

nData = numel(x);
d = zeros(nData);

for i = 1 : nData
  for j = 1 : nData
    if j <= i
      d(i, j) = d(j, i);
    else
      frameDist = dist2(x{i}', x{j}');
      scores = dtw_scores(frameDist);
      d(i, j) = scores(end);
    end
  end
end
end