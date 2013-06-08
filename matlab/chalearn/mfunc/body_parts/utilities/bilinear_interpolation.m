function result = bilinear_interpolation(image, row, col)

% function result = bilinear_interpolation(image, row, col)
%
% row and col are non-integer coordinates, and this function
% computes the value at those coordinates using bilinear interpolation.

% Get the bounding square.
top = floor(row);
left = floor(col);
bottom = top + 1;
right = left + 1;

% Get values at the corners of the square
top_left = image(top, left);
top_right = image(top, right);
bottom_left = image(bottom, left);
bottom_right = image(bottom, right);

x = col - left;
y = row - top;

result = (1 - x) * (1 - y) * top_left;
result = result + x * (1 - y) * top_right;
result = result + x * y * bottom_right;
result = result + (1 - x) * y * bottom_left;
