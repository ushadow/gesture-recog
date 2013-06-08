function hand_trajectories = find_hands_in_sequence(depth_frames, parameters)

% function hand_trajectories = find_hands_in_sequence(depth_frames, parameters)
global debug;

depth_frame = double(depth_frames{1});

% detect the face and initial body position
initial_track = initial_tracking_info(depth_frame, parameters);
current_track = initial_track;

% initialize results
number_of_frames = numel(depth_frames);
hand_trajectories.left = zeros(number_of_frames, 3);
hand_trajectories.right = zeros(number_of_frames, 3);
hand_trajectories.left_centered = zeros(number_of_frames, 3);
hand_trajectories.right_centered = zeros(number_of_frames, 3);
hand_trajectories.left_by_frame = zeros(number_of_frames, 3);
hand_trajectories.right_by_frame = zeros(number_of_frames, 3);
hand_trajectories.left_scores = zeros(number_of_frames, 1);
hand_trajectories.right_scores = zeros(number_of_frames, 1);

magnification_factor = parameters.magnification_param / initial_track.face_info.height;

left_index = 0;
right_index = 0;

% find the hand at each frame
for frame_number = 1:number_of_frames
  depth_frame = depth_frames{frame_number};
  previous_track = current_track;
  [imgi, current_track] = find_hand_initial2(depth_frame, previous_track, parameters);
  if debug
   figure(1); imshow(imgi, []);
  end
  
  if (size(current_track.hand_info.right_position, 1) == 0)
    continue;
  end
  
  current_track = postprocess_tracking_info(current_track, parameters);
  hand_info = current_track.hand_info;
%   disp(sprintf('frame_number = %d, score value = %10.1f', frame_number, hand_info.right_score));
  hand_trajectories.right_by_frame(frame_number, :) = hand_info.right_position;
  hand_trajectories.right_scores(frame_number) = hand_info.right_score;
  
  right_index = right_index+1;
  hand_trajectories.right(right_index, :) = hand_info.right_position;
  hand_trajectories.right_centered(right_index, :) = hand_info.right_normalized;
end

hand_trajectories.left = hand_trajectories.right(1:left_index, :);
hand_trajectories.left_centered = hand_trajectories.left_centered(1:left_index, :);
hand_trajectories.right = hand_trajectories.right(1:right_index, :);
hand_trajectories.right_centered = hand_trajectories.right_centered(1:right_index, :);

