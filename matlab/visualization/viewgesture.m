function viewgesture(data, result, ndx)
%
% ndx   - index in the validation data.

ngestures = data.param.vocabularySize;
seqNDX = data.split{2}(ndx);
im = [data.Y{seqNDX}(1, :); result.prediction.Va{ndx}(1, :); ...
      result.path.Va{ndx}];

colormap(bipolar(ngestures));
image(im);

nrow = size(im, 1);
set(gca, 'YTick', 1 : nrow);
set(gca, 'YTickLabel', {'GT', 'Pred'});
h = colorbar;
set(h, 'YTick', 1 : ngestures);
set(h, 'YTickLabel', gesturelabel);
title(data.file{seqNDX});
end