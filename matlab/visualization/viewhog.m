function H = viewhog(hogData, startNdx, nCell, ndx, w, reorder)
%%
% ARGS
% hogData - Matrix of hog data. Each column is an image.
% reorder - reorder the hog data [false].

if nargin < 5
  w = 5;
end

if nargin < 6
  reorder = false;
end

oBin = 9;

hogData = hogData(startNdx : startNdx + nCell * nCell * oBin - 1, ndx);  
nImages = length(ndx);
hogAll = zeros(nCell * w, nCell * w, 1, nImages);

H = figure();
for j = 1 : nImages
  hog = reshape(hogData(:, j), nCell, nCell, []);
  if reorder
    hog = permute(hog, [2 1 3]);
  end
  image = hogDraw(hog, 1, w);
  if ~reorder
    image = image';
  end
  hogAll(:, :, 1, j) = image;
end
montage(hogAll);
end