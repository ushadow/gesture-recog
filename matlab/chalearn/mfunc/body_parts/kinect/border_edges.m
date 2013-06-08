function result = border_edges(edge_image)

% function result = border_edges(edge_image)
%
% converts border pixels to 1. This is useful for edge images computed
% using the depth_edges function, and before we do connected components on
% them.

[rows, cols] = size(edge_image);
result = edge_image;
result(1, :) = 1;
result(:, 1) = 1;
result(rows, :) = 1;
result(:, cols) = 1;
