function parameters = set_parameters(depth_image)

% function parameters = set_parameters(depth_image)

ft = imread('face_shoulders.gif');

if ((max(depth_image(:)) >= 256) & (size(depth_image, 1) == 480))
  parameters.face_template = ft;
  parameters.hand_score_threshold = 120;
  parameters.extra_depth = 100;
  parameters.depth_edge_low = 70;
  parameters.depth_edge_low_body_segmentation = 10;
  parameters.depth_edge_high = 200;
  parameters.magnification_param = 250;
  parameters.min_gesture_length = 7;
  parameters.pixel_scores_threshold = 80;
  parameters.face_scales = [0.5:0.1:1.8];
  parameters.open_boundary_threshold = 16;
elseif ((max(depth_image(:)) >= 256) & (size(depth_image, 1) == 240))
  parameters.face_template = ft;
  parameters.hand_score_threshold = 120;
  parameters.extra_depth = 100;
  parameters.depth_edge_low = 70;
  parameters.depth_edge_low_body_segmentation = 10;
  parameters.depth_edge_high = 200;
  parameters.magnification_param = 250;
  parameters.min_gesture_length = 7;
  parameters.pixel_scores_threshold = 80;
  parameters.face_scales = [0.25:0.05:0.6, 0.7:0.1:1];
  parameters.open_boundary_threshold = 8;
else % depth values have been mapped to [0-255] range
  parameters.face_template = ft;
  parameters.hand_score_threshold = 20;
  parameters.extra_depth = 10;
%   parameters.extra_depth = 30;
  parameters.depth_edge_low = 4;
  parameters.depth_edge_high = 20;
  parameters.magnification_param = 50;
  parameters.min_gesture_length = 7;
  parameters.pixel_scores_threshold = 10;
  parameters.face_scales = [0.25:0.05:0.6, 0.7:0.1:1];
%   parameters.face_scales = [0.25:0.025:0.7, 0.8:0.1:1];
  parameters.open_boundary_threshold = 8;
  parameters.depth_edge_low_body_segmentation = parameters.depth_edge_low;
  
  % find hands using nearest neighbor search
  load('hands.mat');
  prior_knowledge(1, :) = prior_knowledge(1, :) / 240;
  prior_knowledge(2, :) = prior_knowledge(2, :) / 320;
  prior_knowledge(3, :) = prior_knowledge(3, :) / 255;
  prior_knowledge(4, :) = prior_knowledge(4, :) / 240;
  prior_knowledge(5, :) = prior_knowledge(5, :) / 320;
  prior_knowledge(6, :) = prior_knowledge(6, :) / 255;
  parameters.prior_knowledge = prior_knowledge;

  % find shoulder
  load('shoulder.mat');
  parameters.face_mean = face_mean;
  parameters.inverse_face_cov = inverse_face_cov;
  parameters.left_shoulder_mean = left_shoulder_mean;
  parameters.left_shoulder_face_cov = left_shoulder_face_cov;
  parameters.right_shoulder_mean = right_shoulder_mean;
  parameters.right_shoulder_face_cov = right_shoulder_face_cov;

  %parameters.depth_edge_high_body_segmentation = parameters.depth_edge_high;
end  