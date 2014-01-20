function H = viewhog(hogData, startNdx, cellSize, ndx, w, reorder)
%%
% ARGS
% hogData - Matrix of hog data. Each column is an image.
% imageWidth - image width of the hog image.

if nargin < 5
  w = 5;
end

if nargin < 6
  reorder = false;
end

oBin = 9;

hogData = hogData(startNdx : startNdx + cellSize * cellSize * oBin - 1, ndx);  
nImages = length(ndx);
hogAll = zeros(cellSize * w, cellSize * w, 1, nImages);

H = figure();
for j = 1 : nImages
  hog = reshape(hogData(:, j), cellSize, cellSize, []);
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