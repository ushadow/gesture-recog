function viewhist(X, Y, featureRange, grid, maxLabel, varargin)
% ARGS
% data  - d-by-n matrix

xlabels = {};
titles = {};
for i = 1 : 2 : length(varargin)
  value = varargin{i + 1};
  switch varargin{i}
    case 'xlabels'
      xlabels = value;
    case 'titles'
      titles = value;
  end
end

X = cell2mat(X);
Y = cell2mat(Y);

X = X(:, Y(1, :) < maxLabel);

nBins = 40;
figure;
for i = 1 : length(featureRange)
  ndx = featureRange(i);
  subplot(grid(1), grid(2), i);
  hist(X(ndx, :), nBins);
  col = mod(i - 1, grid(2)) + 1;
  row = floor((i - 1) / grid(2)) + 1;
  if ~isempty(xlabels)
    xlabel(xlabels{col}, 'FontSize', 14);
  end
  if col == 2 && ~isempty(titles)
    title(titles{row}, 'FontSize', 14);
  end
end
end