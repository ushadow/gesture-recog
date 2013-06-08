function [left_shoulder right_shoulder result_image left_box right_box] = detect_shoulder(frame, parameters )
% [left_shoulder right_shoulder result_image left_box right_box] = detect_shoulder(frame, parameters )
% Get shoulder positions from depth frame
% 
% Arguments
% frame -- depth frame image
% parameters -- (optional) algorithm parameters, if not specified, will
% return the value based on the given frame
% 
% Return -- Shoulders position on left and right shoulder
% left_box right_box -- standard [x y w h] bounding boxes
% 
% Usage sample
%     K0 = read_movie('devel01/K_1.avi');
%     [left_shoulder right_shoulder] = detect_shoulder(K(0).cdata);

    if (nargin < 2)
        parameters = set_parameters(frame);
    end                                        
    half_size_box = 2;
    
    if (ndims(frame) == 3)
        frame = double( mean(frame,3) );
    end
    face_info = detect_face(frame);
    observed_face = [face_info.row face_info.col face_info.depth]';
    left_shoulder = find_expected_shoulder(observed_face, parameters.face_mean, parameters.left_shoulder_face_cov, parameters.left_shoulder_mean, parameters.inverse_face_cov);
    right_shoulder = find_expected_shoulder(observed_face, parameters.face_mean, parameters.right_shoulder_face_cov, parameters.right_shoulder_mean, parameters.inverse_face_cov);
    
    binary_body = segment_body(frame, face_info, parameters);
    body = binary_body .* frame;
    % prevent depth_edges function confusing of background as noise. 
    body = 255 - body;
    edges = depth_edges(double(body), parameters.depth_edge_low, parameters.depth_edge_high);
    
    
    [distance index] = bwdist(edges);
    [row col] = ind2sub( size(frame), index(left_shoulder(1), left_shoulder(2) ) );
    left_shoulder(1:2, :) = [row col]';
    [row col] = ind2sub( size(frame), index(right_shoulder(1), right_shoulder(2) ) );
    right_shoulder(1:2, :) = [row col]';
    
    result_image = draw_rectangle1(frame, left_shoulder(1) - half_size_box, left_shoulder(1) + half_size_box, left_shoulder(2) - half_size_box, left_shoulder(2) + half_size_box);
    result_image = draw_rectangle1(result_image, right_shoulder(1) - half_size_box, right_shoulder(1) + half_size_box, right_shoulder(2) - half_size_box, right_shoulder(2) + half_size_box);

    left_box=[ left_shoulder(2) - half_size_box, left_shoulder(1) - half_size_box, half_size_box*2, half_size_box*2];
    right_box=[ right_shoulder(2) - half_size_box, right_shoulder(1) - half_size_box, half_size_box*2, half_size_box*2];

end