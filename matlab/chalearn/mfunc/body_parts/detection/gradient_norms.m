function result = gradient_norms(input_image)

% function result = gradient_norms(input_image)
%
% returns the norm of the gradient at each pixel of the input image.

image = double_gray(input_image);

dx = [-1 0 1; -2 0 2; -1 0 1] / 8;

% dy is the transpose of dx: [-1 -2 -1; 0 0 0; 1 2 1] / 8
dy = dx';

dxb1 = imfilter(image, dx, 'symmetric');
dyb1 = imfilter(image, dy, 'symmetric');
result = (dxb1 .^2 + dyb1 .^2).^0.5;
