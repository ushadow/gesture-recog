function result = nonmaxima_suppression(grad_norms, thetas, distance)

% function result = nonmaxima_suppression(grad_norms, thetas, distance)
% 
% thetas are in range [0 180].

thetas = thetas * pi / 180;
[rows, cols] = size(grad_norms);

% pad image with zeros, to avoid out-of-bounds indexing
grad_norms(rows+1, :) = 0;
grad_norms(:, cols+1) = 0;


result = zeros(rows, cols);
margin = ceil(distance);

for row = (margin+1):(rows-margin)
    for col = (margin+1):(cols-margin)
        if ([row col] == [4, 4])
            sprintf('here');
        end
        angle = thetas(row, col);
        displacement = distance * [sin(angle), cos(angle)];
        center_value = grad_norms(row, col);
        value1 = bilinear_interpolation(grad_norms, row + displacement(1), col + displacement(2));
        value2 = bilinear_interpolation(grad_norms, row - displacement(1), col - displacement(2));
        if (center_value >= value1) & (center_value >= value2)
            result(row, col) = center_value;
        end
    end
end

        