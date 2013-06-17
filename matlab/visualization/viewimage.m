function H = viewimage(data, startNDX, NDX, ncol)
%% VIEWIMAGE displays images for one sequence.
% 
% H = viewhand(data, startNDX, nToDispaly)
%
% Args
% data - d X n matrix where d is the number of pixels in the image and n is 
%        number of frames.

d = size(data, 1);
data = data(startNDX : d, NDX);  
imageWidth = sqrt(d - startNDX + 1);
nimage = length(NDX);
nrow = ceil(nimage / ncol);

H = figure();

for j = 1 : nimage
  % Transposed image.
  image = reshape(data(:, j), imageWidth, imageWidth)';
  image = mat2gray(image);
  subplot(nrow, ncol, j);
  imshow(image);
end
