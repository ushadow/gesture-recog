function [result_image, tracking_info] = ...
  find_hand_initial2(depth_frame, previous_tracking_info, parameters)
                 
% function [result_image, tracking_info] = ...
%  find_hand_initial2(depth_frame, previous_tracking_info, parameters)
%
% identifies hand candidates by finding differences to initial 
% appearance-based pose of the person (represented as the depth values of
% pixels belonging to the person). 
        
current = double(depth_frame);
face_info = previous_tracking_info.face_info;
initial_pose = previous_tracking_info.initial_body_pose;
tracking_info = previous_tracking_info;

magnification_factor = parameters.magnification_param / face_info.height;

[rows, cols] = size(current);
selection = segment_body(current, face_info, parameters);

current_pose = selection .* current;

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
binary = (pixel_scores > parameters.pixel_scores_threshold);

parameters.required_area = round((face_info.height / 10) ^ 2);
parameters.square_side = (round(face_info.height/6)) * 2 + 1;
parameters.number_of_results = 1;
parameters.face_info = face_info;

%[result_image, result_centers] = candidates_from_connected(current, pixel_scores, binary, parameters);
%result_side = parameters.square_side;

edges = depth_edges(current, parameters.depth_edge_low, parameters.depth_edge_high);
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
  tracking_info.hand_info.right_position = [];
  return;
end

max_label = sorted_labels(max_label_indices(1));
selected = (labels_image == max_label);

%[result_image, result_center, result_score] = find_hand_from_depth_smoothness(current, pixel_scores.*selected, edges, previous_tracking_info, parameters);
[result_image, result_center, result_score] = find_hand_from_depth_smoothness(current, pixel_scores.*selected, previous_tracking_info, parameters);

if (result_score < parameters.hand_score_threshold)
%   disp(sprintf('\n***************score from depth smoothness too low: %f', result_score));
  result_center = [];
end

if numel(result_center) == 0
  [result_image, result_center, result_score] = candidates_from_connected(current, pixel_scores.*selected, selected, parameters);

  if (result_score < parameters.hand_score_threshold)
%     disp(sprintf('\n***************score from connected components too low: %f', result_score));
    result_center = [];
    result_image = [];
  end
end

result_side = parameters.square_side;
tracking_info = previous_tracking_info;
tracking_info.hand_info.right_position = result_center;
tracking_info.hand_info.right_score = result_score;
tracking_info.hand_info.size = result_side;

