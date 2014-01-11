function H = viewhog(hogData, imageWidth, ndx, w)
%%
% ARGS
% hogData - Matrix of hog data. Each column is an image.
% imageWidth - image width of the hog image.

if nargin < 4
  w = 4;
end

hogData = hogData(:, ndx);  
nImages = length(ndx);
hogAll = zeros(imageWidth * w, imageWidth * w, 1, nImages);

H = figure();
for j = 1 : nImages
  hog = reshape(hogData(:, j), imageWidth, imageWidth, []);
  image = hogDraw(hog, 1, w);
  hogAll(:, :, 1, j) = image';
end
montage(hogAll);
end