function viewrecogresult(data, result, ndx, gestureLabel)
% Visualize gesture recognition result.
%
% ARGS
% ndx   - index in the validation data.

figure;
ngestures = data.param.vocabularySize;
seqNDX = result.split{2}(ndx);

im = [data.Y{seqNDX}(1, :); result.prediction.Va{ndx}(1, :)];

colormap(bipolar(ngestures));
image(im);

xtick = get(gca, 'XTick');
set(gca, 'XTickLabel', data.frame{seqNDX}(xtick));
xlabel('Time t', 'FontSize', 14);

nrow = size(im, 1);
ytick = 1 : nrow;
line(repmat(xlim', 1, length(ytick) - 1), ...
     repmat((ytick(2 : end) + ytick(1 : end - 1)) / 2, 2, 1), 'Color', 'k');

set(gca, 'YTick', ytick);
set(gca, 'YTickLabel', {'Ground truth', 'Prediction'}, 'FontSize', 14);
yticklabel_rotate;

h = colorbar;
set(h, 'YTick', 1 : ngestures);
set(h, 'YTickLabel', gestureLabel, 'FontSize', 12);
title(data.file{seqNDX}, 'Interpreter', 'none');

if ~isempty(result.path)
  hiddenStates = result.path.Va{ndx};
  ncolors = max(hiddenStates);
  yTickLabel = {'Hidden states'};
  drawimage(hiddenStates, ncolors, data.frame{seqNDX}(xtick), yTickLabel);
end
end

function drawimage(data, ncolors, xTickLabel, yTickLabel)
figure;
colormap(bipolar(ncolors));
image(data);

set(gca, 'XTickLabel', xTickLabel);
xlabel('Time t', 'FontSize', 14);

nrow = size(data, 1);
ytick = 1 : nrow;
set(gca, 'YTick', ytick); 
set(gca, 'YTickLabel', yTickLabel, 'FontSize', 14);
yticklabel_rotate;
h = colorbar;
set(h, 'YTick', 1 : ncolors);
set(h, 'YTickLabel', 1 : ncolors, 'FontSize', 12);
end