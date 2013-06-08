function result = color_code(depth_image)

% function result = color_code(depth_image)
%
% color code:
% white -> yellow -> red -> green -> blue

nonzero = (depth_image > 0);
nonzero_values = depth_image(nonzero);
minimum = min(nonzero_values);
maximum = max(nonzero_values);
nonzero_values = nonzero_values - minimum + 1;
nonzero_values = nonzero_values * (1020/(maximum-minimum+1));
nonzero_values = round(nonzero_values);
depth_image(nonzero) = nonzero_values;

rows = size(depth_image, 1);
cols = size(depth_image, 2);

result = zeros(rows, cols, 3, 'uint8');
red = zeros(rows, cols, 'uint8');
green = zeros(rows, cols, 'uint8');
blue = zeros(rows, cols, 'uint8');

% selected = ((depth_image > 0) & (depth_image <= 255));
% red(selected) = 255;
% green(selected) = depth_image(selected);
% blue(selected) = 0;
% 
% selected = ((depth_image > 255) & (depth_image <= 2*255));
% red(selected) = 510 - depth_image(selected);
% green(selected) = 255;
% blue(selected) = 0;
% 
% selected = ((depth_image > 2*255) & (depth_image <= 3*255));
% red(selected) = 0;
% green(selected) = 255;
% blue(selected) = depth_image(selected) - 510;
% 
% selected = ((depth_image > 3*255) & (depth_image <= 4*255));
% red(selected) = 0;
% green(selected) = 1020-depth_image(selected);
% blue(selected) = 255;

selected = ((depth_image > 0) & (depth_image <= 255));
red(selected) = 255;
green(selected) = 255;
blue(selected) = 255 - depth_image(selected);

selected = ((depth_image > 255) & (depth_image <= 2*255));
red(selected) = 255;
green(selected) = 510 - depth_image(selected);
blue(selected) = 0;

selected = ((depth_image > 2*255) & (depth_image <= 3*255));
red(selected) = 765 - depth_image(selected);
green(selected) = depth_image(selected) - 510;
blue(selected) = 0;

selected = ((depth_image > 3*255) & (depth_image <= 4*255));
red(selected) = 0;
green(selected) = 1020-depth_image(selected);
blue(selected) = depth_image(selected) - 765;

result(:,:,1) = red;
result(:,:,2) = green;
result(:,:,3) = blue;
