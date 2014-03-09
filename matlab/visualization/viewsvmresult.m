function viewsvmresult(data, ndx, param)

figure;
nGesture = param.vocabularySize;
gestureLabel = param.gestureLabel(5 : 8);
gestureLabel = ['Other'; gestureLabel];

gt = data.Y{ndx}(1, :);
pred = data.X{ndx}(end, :);

gt = gt - 3;
im = [gt; pred];

color = bipolar(nGesture);
colormap(color(4 : 8, :));
image(im);

xtick = get(gca, 'XTick');
set(gca, 'XTickLabel', data.frame{ndx}(xtick));
xlabel('Time t', 'FontSize', 14);

nrow = size(im, 1);
ytick = 1 : nrow;
line(repmat(xlim', 1, length(ytick) - 1), ...
     repmat((ytick(2 : end) + ytick(1 : end - 1)) / 2, 2, 1), 'Color', 'k');
   
set(gca, 'YTick', ytick);
set(gca, 'YTickLabel', {'Ground truth', 'Prediction'}, 'FontSize', 14);
yticklabel_rotate;

h = colorbar;
set(h, 'YTick', 1 : length(gestureLabel));
set(h, 'YTickLabel', gestureLabel, 'FontSize', 14);
end
