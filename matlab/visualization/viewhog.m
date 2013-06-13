function H = viewhog(hogData, imageWidth, NDX, ncol)
%%
% ARGS
% hogData - Matrix of hog data.
% imageWidth - image width of the hog image.

hogData = hogData(:, NDX);  
nimage = length(NDX);
nrow = ceil(nimage / ncol);

H = figure();
for j = 1 : nimage
  hog = reshape(hogData(:, j), imageWidth, imageWidth, []);
  image = hogDraw(hog, 1);
  subplot(nrow, ncol, j);
  imshow(image');
end
end