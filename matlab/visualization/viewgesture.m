function viewgesture(data, result, ndx)
%
% ndx   - index in the validation data.

figure;
ngestures = data.param.vocabularySize;
seqNDX = result.split{2}(ndx);
nS = sum(cell2mat(values(result.param.nSMap)));
im = [data.Y{seqNDX}(1, :); result.prediction.Va{ndx}(1, :); ...
      result.path.Va{ndx} * ngestures / nS];

colormap(bipolar(ngestures));
image(im);

nrow = size(im, 1);
xtick = get(gca, 'XTick');
set(gca, 'XTickLabel', data.frame{seqNDX}(xtick));

set(gca, 'YTick', 1 : nrow);
set(gca, 'YTickLabel', {'Ground truth', 'Prediction', 'Hidden states'});

h = colorbar;
set(h, 'YTick', 1 : ngestures);
set(h, 'YTickLabel', gesturelabel);
title(data.file{seqNDX});
end