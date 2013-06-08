function points = image2points(image)
% IMAGE2POINTS converts a depth image into points. 
%
% points = image2points(image)
%
% Args:
% The image is stored as
% image: a column vector where pixels in the same row are contiguous.

n = sqrt(length(image));

points = zeros(n * n, 3);

points(:, 1) = repmat((0 : n - 1)', [n 1]); % x
points(:, 2) = reshape(repmat(0 : n - 1, [n 1]), [n * n 1]);
points(:, 3) = image;

index = points(:, 3) ~= 0;
points = points(index, :);
end