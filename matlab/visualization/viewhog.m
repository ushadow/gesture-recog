function H = viewhog(hogData, imageWidth, nimage)
%%
% ARGS
% hogData - Matrix of hog data.
% imageWidth - image width of the hog image.

NCOL = 3;

NDX = floor(linspace(1, size(hogData, 2), nimage)); 
hogData = hogData(:, NDX);  

H = figure();

nrow = ceil(nimage / NCOL);

for j = 1 : nimage
  hog = reshape(hogData(:, j), imageWidth, imageWidth, []);
  image = hogDraw(hog, 1);
  subplot(nrow, NCOL, j);
  imshow(image');
end
end