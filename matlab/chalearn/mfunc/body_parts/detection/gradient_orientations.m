function result = gradient_orientations(arg1, arg2);

% gradient_orientations: compute the edge orientations of an image, in 
% range 0 to 180.
%
% function result = gradient_orientations(gradient_x, gradient_y);
%
%
% computes the gradient orientation at each pixel of an image, given
% the x gradient and y gradient for each pixel of the image.
%
% function result = gradient_orientations(image);
%
% computes the gradient orientation at each pixel of an image, by first
% computing the x and y gradients at each pixel of the image.
%
% function result = gradient_orientations(image, sigma);
%
% blurs the image with a Gaussian filter of std=sigma (where sigma is 
% a scalar), then computes the x
% and y gradients of the blurred image, and finally computes the gradient
% orientation at each pixel.
%
% convention: 
% - assume pixel coordinates (x increases towards right, y increases
% towards bottom)
% - zero angle is towards right
% - angles increase clockwise
% 


% figure out if we need to compute gradients
compute_gradients = 0;
if (nargin == 1)
    image = arg1;
    compute_gradients = 1;
end

if ((nargin == 2) & (isscalar(arg2)))
    original_image = arg1;
    sigma = arg2;
    image = blur_image(original_image, sigma);
    compute_gradients = 1;
end

if (compute_gradients)  % if we need to compute gradients
    dx = [-1 0 1; -2 0 2; -1 0 1] / 8;
    dy = dx';

    % compute dx, dy, and gradient
    gradient_x = imfilter(image, dx, 'same', 'symmetric');
    gradient_y = imfilter(image, dy, 'same', 'symmetric');
else  % if the function arguments are gradient_x and gradient_y
    gradient_x = arg1;
    gradient_y = arg2;
end
    
% compute edge orientations
%thetas =  -atan2(gradient_y, gradient_x);  %incorrect, angles increase counterclockwise
thetas =  atan2(gradient_y, gradient_x);  %correct, angles increase clockwise
%thetas =  atan2(gradient_x, gradient_y);  % extremely incorrect
%thetas =  -atan2(gradient_x, gradient_y);  % rather incorrect

% convert orientations to [0 180] range.
result = thetas / pi * 180;
result(result < 0) = result(result < 0) + 180;
result(result > 180) = 180;



