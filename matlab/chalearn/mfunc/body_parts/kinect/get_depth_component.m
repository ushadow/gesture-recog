function result = get_depth_component(frame, low_threshold, high_threshold, i, j)

% function result = get_depth_component(frame, low_thr, high_thr, i, j)
%
% we assume that frame is a depth image (from Kinect)
% first computes edges using depth_edges, and then finds the connected
% component of the specified pixel (i, j)

[rows, cols] = size(frame);
edges = depth_edges(frame, low_threshold, high_threshold);
binary = ~edges;
binary(1, :) = 0;
binary(:, 1) = 0;
binary(rows, :) = 0;
binary(:, cols) = 0;

result = get_pixel_component(binary, i, j);
