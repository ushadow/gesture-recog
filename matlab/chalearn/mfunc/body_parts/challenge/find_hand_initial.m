function [result_image, result_centers, result_side] = ...
  find_hand_initial(current, initial_pose, face_info, ...
                   previous_result, parameters)
                 
% function [result_image, result_centers, result_side] = ...
%   find_hand_initial(current, initial_pose, face_info, ...
%                    previous_result, parameters)
%
% identifies hand candidates by finding differences to initial 
% appearance-based pose of the person (represented as the depth values of
% pixels belonging to the person).
                 
if ((nargin < 5) | (size(parameters < 1)))
  extra_depth = 100;  
else
  extra_depth = parameters(1);
end


if ((nargin < 5) | (size(parameters < 1)))
  depth_edge_low = 20;  
else
  depth_edge_low = parameters(2);
end

if ((nargin < 5) | (size(parameters < 1)))
  depth_edge_high = 200;  
else
  depth_edge_high = parameters(1);
end

[rows, cols] = size(current);
selection = segment_body(current, face_info, [extra_depth, depth_edge_low, depth_edge_high]);

current_pose = selection .* current;

% magnification factor is measured in mm/pixel
magnification_factor = 250/face_info.height;

initial_binary = (initial_pose > 0);
initial_dt = bwdist(initial_binary);
dt_term = selection .* initial_dt * magnification_factor;

% this helps handle cases where the hand is close to initial position, but
% outside of it (pixelwise). Here we assign "initial" depth values to such
% pixels, so that we can identify that the hand is closer than those
% values.
extended_initial_depth = initial_pose;
for row = 1:rows
  columns = find(initial_binary(row, :));
  
  if (numel(columns) == 0)
    extended_initial_depth(row, :) = face_info.depth;
    continue;
  end
  
  left = columns(1);
  right = columns(numel(columns));
  left_depth = initial_pose(row, left);
  right_depth = initial_pose(row, right);
  extended_initial_depth(row, 1:left) = left_depth;
  extended_initial_depth(row, right:cols) = right_depth;
end

diff = extended_initial_depth - current_pose;
diff(current_pose == 0) = 0;
diff(diff < 0) = 0;
diff_term = diff;
pixel_scores = dt_term + diff_term;
binary = (pixel_scores > 80);

parameters = struct('required_area', 'square_side');
parameters.required_area = round((face_info.height / 10) ^ 2);
parameters.square_side = (round(face_info.height/6)) * 2 + 1;
parameters.number_of_results = 1;

%[result_image, result_centers] = candidates_from_connected(current, pixel_scores, binary, parameters);
%result_side = parameters.square_side;

edges = depth_edges(current, 30, 200);
binary(edges ~= 0) = 0;
%figure(5); imshow(edges, []);

[labels_image, sorted_labels, sorted_areas] = connected_components(binary);
number = numel(sorted_labels);
component_scores = zeros(number, 1);

for counter = 1:number
  values = pixel_scores(labels_image == sorted_labels(counter));
  if (numel(values) < parameters.required_area)
    break;
  end
  component_scores(counter) = mean(values);
end

number = sum(component_scores);
max_score = max(component_scores);
max_label_indices = find(component_scores == max_score);
if (numel(max_label_indices) == 0)
  result_image = [];
  result_centers = [];
  result_side = [];
  return;
end

max_label = sorted_labels(max_label_indices(1));

selected = (labels_image == max_label);

% for debugging
%component = largest_connected(binary);
figure(3); imshow(edges, []);
figure(4); imshow(pixel_scores.*selected, []);

[result_image, result_centers] = candidates_from_connected(current, pixel_scores.*selected, selected, parameters);
result_side = parameters.square_side;
