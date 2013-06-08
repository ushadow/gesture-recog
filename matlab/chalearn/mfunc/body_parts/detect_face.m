function [face_info result_image] = detect_face(depth_frame, parameters)
% face_info = detect_face(depth_frame, parameters)
% Get face from depth frame
% 
% Arguments
% depth_frame -- depth frame image
% parameters -- (optional) algorithm parameters, if not specified, will
% return the value based on the given frame
% 
% Return -- Face struct consists of bounding box, contour and central
% depth
% 
% Usage sample
%     K0 = read_movie('devel01/K_1.avi');
%     face_info = detect_face(K(0).cdata);


% Author: Pat Jangyodsuk and Vassilis Athitsos -- November 2011

debug=0;

if (ndims(depth_frame) == 3)
    depth_frame = double( mean(depth_frame,3) );
end
if (nargin < 2)
    parameters = set_parameters(depth_frame);
end

de = depth_edges(depth_frame, parameters.depth_edge_low, parameters.depth_edge_high);

% detect the face
ft = parameters.face_template;
[scorestoim, scorestotemp, scales] = chamfer_multiscale(de, ft, parameters.face_scales); 
scores = scorestoim + scorestotemp;

number_of_face_candidates = 10;

[result_image, result_centers, result_scales] = ...
  multiscale_detection_results(color_code(depth_frame), -scores, scales, size(ft), 1, number_of_face_candidates);

pass_criteria = false;
for i=1:number_of_face_candidates
  face_center = result_centers(i, :);
  face_size = round(size(ft) * result_scales(i));
  face_info.row = face_center(1);
  face_info.col = face_center(2);
  face_info.height = face_size(1);
  face_info.width = face_size(2);
  face_info.depth = depth_frame(face_center(1), face_center(2));

  % sanity check: if we got an invalid center, continue.
  if (face_info.depth == 0)
    continue;
  end
  

      half_rows = floor(face_info.height / 2);
    half_cols = floor(face_info.width / 2);
    valid_sum = sum(depth_frame(:) > 0);
    body = segment_body(depth_frame, face_info, parameters);
    
    body_sum = sum(body(:));
    over_face_sum = sum( sum(body(1:face_info.row, :)) );
    

    under_face_sum = sum( sum(body(   min( size(depth_frame,1), face_info.row + half_rows):size(depth_frame, 1), ...
                                 max(1, face_info.col - half_cols):min(size(depth_frame,2), face_info.col + half_cols)) ));
    
    % hack: number of body segment pixels above and under face should be reasonable 
    if ( (body_sum / valid_sum > 0.7) || (body_sum / valid_sum < 0.1) )
        continue;
    end
    if (over_face_sum / body_sum > 0.2)
        continue;
    end
    if (under_face_sum / body_sum < 0.3)
        continue;
    end

    pass_criteria = true;
    break;
end

if ~pass_criteria
    face_center = result_centers(1, :);
    face_size = round(size(ft) * result_scales(1));
    face_info.row = face_center(1);
    face_info.col = face_center(2);
    face_info.height = face_size(1);
    face_info.width = face_size(2);
    face_info.depth = depth_frame(face_center(1), face_center(2));
    
end

%%% Uncomment these lines to see function result image
 result_image = draw_rectangle2(color_code(depth_frame), face_info.row, face_info.col, ...
                               face_info.height, face_info.width);

if debug; figure(2); imshow(result_image/255, []); end

face_info.row = face_center(1);
face_info.col = face_center(2);
face_info.height = face_size(1);
face_info.width = face_size(2);
face_info.depth = depth_frame(face_center(1), face_center(2));

% detect the initial position of the person
initial_body_pose = segment_body(depth_frame, face_info, parameters);
initial_body_pose = initial_body_pose .* depth_frame;

face_mask = zeros(size(depth_frame));

half_rows = floor(face_info.height / 2);
half_cols = floor(face_info.width / 2);

current_top = face_info.row - half_rows;
current_bottom = face_info.row + half_rows;
current_left = face_info.col - half_cols;
current_right = face_info.col + half_cols;

no_row = size(depth_frame, 1);
no_col = size(depth_frame, 2);

face_info.bounding_box.top = max(current_top, 1);
face_info.bounding_box.bottom = min(current_bottom, no_row);
face_info.bounding_box.left = max(current_left, 1);
face_info.bounding_box.right = min(current_right, no_col);

face_mask(face_info.bounding_box.top:face_info.bounding_box.bottom, face_info.bounding_box.left:face_info.bounding_box.right) = 1;
face_info.contour = face_mask .* initial_body_pose;

