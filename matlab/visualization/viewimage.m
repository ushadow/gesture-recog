function H = viewimage(data, startNdx, indices, ncol)
%% VIEWIMAGE displays images for one sequence.
% 
% H = viewimage(data, startNDX, nToDispaly)
%
% ARGS
% data - d X n matrix where d is the number of pixels in the image and n is 
%        number of frames.
% startNdx  - start index of descriptor
% indices   - indices of images to be displayed

d = size(data, 1);
data = data(startNdx : d, indices);  
imageWidth = sqrt(d - startNdx + 1);
nimage = length(indices);
nrow = ceil(nimage / ncol);

H = figure();

for j = 1 : nimage
  % Transposed image.
  image = reshape(data(:, j), imageWidth, imageWidth)';
  image = mat2gray(image);
  subplot(nrow, ncol, j);
  imshow(image);
end
