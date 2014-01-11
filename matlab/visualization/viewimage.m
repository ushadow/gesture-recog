function H = viewimage(data, startNdx, imageWidth, indices)
%% VIEWIMAGE displays images for one sequence.
% 
% H = viewimage(data, startNDX, nToDispaly)
%
% ARGS
% data - d X n matrix where d is the number of pixels in the image and n is 
%        number of frames.
% startNdx  - start index of descriptor
% indices   - indices of images to be displayed

if nargin < 2
  startNdx = 1; 
  imageWidth = 64;
  indices = 1 : size(data, 2);
end

data = data(startNdx : startNdx + imageWidth * imageWidth - 1, indices);  
nImages = length(indices);

H = figure();
image = reshape(data, imageWidth, imageWidth, 1, nImages);
image = permute(image, [2 1 3 4]);
image = mat2gray(image);
montage(image);
end