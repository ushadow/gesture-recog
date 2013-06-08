function H = viewhand(data, startNDX, nrow, ncol)
% VIEWHAND displays hand images for one sequence.
% 
% H = viewhand(data, startNDX, nToDispaly)
%
% Args
% data: N X M matrix where N is the number of pixels in the image and M is 
%       number of frames.
N = size(data, 1);

if isempty(startNDX)
  startNDX = 1;
end

nimage = nrow * ncol;
data = data(startNDX : N, 1 : nimage);  

imageWidth = sqrt(N - startNDX + 1);

H = figure();

for j = 1 : nimage
  hand = reshape(data(:, j), imageWidth, imageWidth)';
  image = mat2gray(hand);
  subplot(nrow, ncol, j);
  imshow(image);
end
