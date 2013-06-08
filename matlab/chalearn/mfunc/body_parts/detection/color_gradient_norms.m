function result = color_gradient_norms(input_image)

% function result = color_gradient_norms(input_image)
%
% returns the norm of the gradient at each pixel of the input image,
% combining information from the different color channels

if size(input_image, 3) ~= 3
    error('color_gradient_norms called with non-color image');
end

input_image = double(input_image);

dx = [-1 0 1; -2 0 2; -1 0 1] / 8;

% dy is the transpose of dx: [-1 -2 -1; 0 0 0; 1 2 1] / 8
dy = dx';

result = zeros(size(input_image, 1), size(input_image, 2));

for i=1:3
    dxb1 = imfilter(input_image(:, :, i), dx, 'symmetric');
    dyb1 = imfilter(input_image(:, :, i), dy, 'symmetric');
    result = result + ((dxb1 .^2 + dyb1 .^2).^0.5);
end

