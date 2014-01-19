function H = viewhog(hogData, startNdx, cellSize, ndx, w)
%%
% ARGS
% hogData - Matrix of hog data. Each column is an image.
% imageWidth - image width of the hog image.

if nargin < 5
  w = 5;
end

oBin = 9;

hogData = hogData(startNdx : startNdx + cellSize * cellSize * oBin - 1, ndx);  
nImages = length(ndx);
hogAll = zeros(cellSize * w, cellSize * w, 1, nImages);

H = figure();
for j = 1 : nImages
  hog = reshape(hogData(:, j), cellSize, cellSize, []);
  image = hogDraw(hog, 1, w);
  hogAll(:, :, 1, j) = image';
end
montage(hogAll);
end