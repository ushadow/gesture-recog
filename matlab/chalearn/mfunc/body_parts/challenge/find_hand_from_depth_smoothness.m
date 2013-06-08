function [result_image, result_center, result_score] = ...
  find_hand_from_depth_smoothness(depth_image, scores, previous_tracking_info, parameters)
                 
% function [result_image, result_center, result_score] = ...
%   find_hand_from_depth_smoothness(depth_image, scores, depth_edges, previous_tracking_info, parameters)
%
% here we assume that selected has a single connected component

result_image = [];
result_center = [];
result_score = [];


% extract the boundary
selected = (scores ~= 0);
selected = imfill(selected, 'holes');
[pixel_rows, pixel_cols] = find(selected ~= 0);
if (numel(pixel_rows) == 0)
  return;
end
initial = [pixel_rows(1), pixel_cols(1)];
contour_pixels = bwtraceboundary(selected, initial, 'N');

% find (heuristically) diameter: two points that are far from each other.
[row1, col1, row2, col2, dist] = heuristic_diameter(contour_pixels);
if dist < parameters.face_info.height
  return;
end

center = zeros(3, 2);
score = zeros(2, 1);
[center(:, 1), score(1)] = get_hand_center(depth_image, parameters, row1, col1, selected, scores);
[center(:, 2), score(2)] = get_hand_center(depth_image, parameters, row2, col2, selected, scores);

normalized1 = center(:, 1) - [previous_tracking_info.face_info.row, previous_tracking_info.face_info.col, previous_tracking_info.face_info.depth]';
normalized2 = center(:, 2) - [previous_tracking_info.face_info.row, previous_tracking_info.face_info.col, previous_tracking_info.face_info.depth]';


hand_index = find_hand_and_elbow(normalized1, normalized2, parameters);
result_center = center(:, hand_index)';
result_score = score(hand_index);

[rows, cols] = size(depth_image);
half_side = floor(parameters.square_side / 2);
result_image = draw_rectangle1(depth_image, ...
                                     max(1, result_center(1) - half_side),...
                                     min(rows, result_center(1) + half_side),...
                                     max(1, result_center(2) - half_side),...
                                     min(cols, result_center(2) + half_side));

