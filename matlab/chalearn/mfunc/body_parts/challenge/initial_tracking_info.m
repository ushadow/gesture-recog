function result = initial_tracking_info(depth_frame, parameters)

% function result = initial_tracking_info(depth_frame, parameters)
global debug;

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
  
%   % sanity check: there should not be too many pixels at same or
%   % smaller depth than the face.
%   sum1 = sum(depth_frame(:) > 0);
%   sum2 = sum((depth_frame(:) > 0) & (depth_frame(:) <= (face_info.depth + parameters.extra_depth)));
%   if  (sum2/sum1 > 0.5) 
%     continue;
%   end
  
  % possible second sanity check: there should not be too many body pixels
  % above the face. Implement later

      half_rows = floor(face_info.height / 2);
    half_cols = floor(face_info.width / 2);
    valid_sum = sum(depth_frame(:) > 0);
    body = segment_body(depth_frame, face_info, parameters);
    body_sum = sum(body(:));
    over_face_sum = sum( sum(body(1:face_info.row, :)) );
    

    under_face_sum = sum( sum(body(   min( size(depth_frame,1), face_info.row + half_rows):size(depth_frame, 1), ...
                                 max(1, face_info.col - half_cols):min(size(depth_frame,2), face_info.col + half_cols)) ));
    

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
    body = segment_body(depth_frame, face_info, parameters);
end
  
if debug
    result_image = draw_rectangle2(color_code(depth_frame), face_info.row, face_info.col, ...
                                   face_info.height, face_info.width);

    figure(1); imshow(depth_frame, []);
    figure(2); imshow(result_image/255, []);
end

face_info.row = face_center(1);
face_info.col = face_center(2);
face_info.height = face_size(1);
face_info.width = face_size(2);
face_info.depth = depth_frame(face_center(1), face_center(2));

% detect the initial position of the person
face_depth = depth_frame(face_center(1), face_center(2));
initial_body_pose = segment_body(depth_frame, face_info, parameters);
initial_body_pose = initial_body_pose .* depth_frame;

result.face_info = face_info;
result.initial_body_pose = initial_body_pose;
