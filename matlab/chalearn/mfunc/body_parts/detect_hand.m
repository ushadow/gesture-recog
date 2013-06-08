function [hand, result_image] = detect_hand(depth_frame, arg2, ...
    initial_pose, parameters)
% [hand result_image bnd_box] = detect_hand(depth_frame, arg2, initial_pose, parameters)
% Get hand information from depth frame, note that, if the score is too
% low, it won't detect anything at all.
% 
% Two usages
% 1 - detect_hand(current_frame, first_frame)
% 2 - detect_hand(current_frame, face, first_frame_body_segment,
%                   (optional) parameters )
% 2nd usage is faster
% Arguments
% depth_frame -- depth frame image
% first_frame -- first frame of the batch
% face_info -- face struct of first frame
% initial_pose -- body segment of the first frame in this video
% parameters -- (optional) algorithm parameters, if not specified, will
% return the value based on the given frame
% 
% Return -- Hand info consists of bounding box and position
% bnd_box -- standard [x y w h] bounding box
% 
% Usage sample
%     K0 = read_movie('devel01/K_1.avi');
%     hand = detect_hand(K0(10).cdata, K(1).cdata);

% Author: Pat Jangyodsuk and Vassilis Athitsos -- November 2011

debug = 0;

if (ndims(depth_frame) == 3)
    depth_frame = double( mean(depth_frame,3) );
end
% second paramters is first frame
if (nargin == 2)
    parameters = set_parameters(depth_frame);
    first_frame = arg2;
    face_info = detect_face(first_frame, parameters);
    initial_pose = detect_body_segment(first_frame, face_info, parameters);
else
    if (nargin == 3)
        parameters = set_parameters(depth_frame);
    end
    face_info = arg2;
end

result_image = depth_frame;
current = double(depth_frame);

magnification_factor = parameters.magnification_param / face_info.height;
previous_tracking_info.face_info = face_info;
previous_tracking_info.body_pose_initial = initial_pose;

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


edges = depth_edges(current, parameters.depth_edge_low, parameters.depth_edge_high);
binary(edges ~= 0) = 0;

[labels_image, sorted_labels] = connected_components(binary);
number = numel(sorted_labels);
component_scores = zeros(number, 1);

for counter = 1:number
  values = pixel_scores(labels_image == sorted_labels(counter));
  if (numel(values) < parameters.required_area)
    break;
  end
  component_scores(counter) = mean(values);
end

max_score = max(component_scores);
max_label_indices = find(component_scores == max_score);
if (numel(max_label_indices) == 0)
   
   hand.position = [];
   hand.bounding_box = [];
  return;
end

max_label = sorted_labels(max_label_indices(1));
selected = (labels_image == max_label);

[result_image, result_center, result_score] = find_hand_from_depth_smoothness(current, pixel_scores.*selected, previous_tracking_info, parameters);

if (result_score < parameters.hand_score_threshold)
  result_center = [];
end

if numel(result_center) == 0
  [result_image, result_center, result_score] = candidates_from_connected(current, pixel_scores.*selected, selected, parameters);

  if (result_score < parameters.hand_score_threshold)
      hand.position = [];
      hand.bounding_box = [];
      return;
  end
end

hand.position = [];
hand.bounding_box = [];

if (numel(result_center) > 0)
    half = round(parameters.square_side / 2);
    no_row = size(depth_frame, 1);
    no_col = size(depth_frame, 2);

    bounding_box.top = max(result_center(1) - half, 1);
    bounding_box.bottom = min(result_center(1) + half, no_row);
    bounding_box.left = max(result_center(2) - half, 1);
    bounding_box.right = min(result_center(2) + half, no_col);
    hand.bounding_box = bounding_box;

    % this can be used as an input to normalize function
    hand.position = result_center;
end

%%% Uncomment this line to display result
if debug, figure(1); imshow(result_image, [] ); end


end