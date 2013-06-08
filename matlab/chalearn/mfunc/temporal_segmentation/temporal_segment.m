function [gestures motion_scores] = temporal_segment(depth, rgb, parameters)
%[gestures motion_scores] = temporal_segment(depth, rgb, parameters)
% Function performing temporal segmentation of a video based on motion,
% without using dynamic time warping. The method can be used in on-line
% mode, ie without waiting for the end of the video.
% Input:
% depth -- depth video
% rgb -- RGB video
% Returns:
% gestures -- an array nx2 indicating in time the position of the temporal
% segmentation points. gesture(k,1) = start poijnt, gesture(k, 2) = end
% point, for each gesture.
% motion_scores -- a temporal sequence indicating the scores of motion.

% Pat Jangyodsuk and Vassilis Athitsos -- June 2012

% Go back to a gray level image
number_of_frames = length(depth);
first_frame = depth(1).cdata;
if ( length(size(first_frame)) == 3)
   for i=1:number_of_frames
       depth(i).cdata = double(mean(depth(i).cdata, 3));
   end
end

% Compute parameters (note, this could be already computed elsewhere
if (nargin < 3)
   parameters = set_parameters(depth(1).cdata); 
end


% 'waiting' means we are waiting for a gesture to start, 'observing' means we are observing a gesture.
current_mode = 'waiting'; 
current_features.frame = 0;
current_features.tracking_info = initial_tracking_info(double(depth(1).cdata), parameters);
gesture_flag = zeros(number_of_frames, 1);

neutral_start_frame = 1;

for frame = 1:number_of_frames

  last_features = current_features;
  [result_image, tracking_info] = find_hand_initial2(depth(frame).cdata, last_features.tracking_info, parameters);
  
    if (numel(tracking_info.hand_info.right_position) ~= 0)
        neutral_position_interval = frame - neutral_start_frame;
        if (strcmp(current_mode, 'waiting') && (neutral_position_interval > parameters.min_resting_length)) % we found the first frame of a gesture
            start = frame;
            current_mode = 'looking';
       end
        
   
    
    else 
        if (strcmp(current_mode, 'waiting')) % waiting for a gesture to start
          continue;
        end
    
        % here is a frame where we found no hands, whereas in the previous
        % frame we did. This indicates the end of a gesture.

        % reject the gesture if it is too short
        gesture_length = frame - start;
        if (gesture_length >= parameters.min_gesture_length)
            
          gesture_flag(start:frame-1) = 1;
          neutral_start_frame = frame;
          
        end
    
        current_mode = 'waiting';
    end
end  


% Filter using motion
motion = motion_sequence2(rgb);
neutral_position_frames = find(gesture_flag == 0);
neutral_position_frames = neutral_position_frames(2:end-1);

motion_scores = zeros(number_of_frames, 1);
for i=1:length(neutral_position_frames)
    frame_no = neutral_position_frames(i);
    noise = (motion{frame_no-1} <= 30);
    frame = motion{frame_no-1} / 255;
    frame(noise) = 0;
    motion_score = ( sum(frame(:)) * 18) / (size(frame,1) * size(frame,2) );
    motion_scores(frame_no) = motion_score;
    if (motion_score > 0.025)
        gesture_flag(frame_no) = 1;
    end 
end

% First 5 percentile and last 5 percentile of frames are deemed as resting
% position interval
% five_percent = floor(number_of_frames * 0.05);
% gesture_flag(1:five_percent) = 0;
% gesture_flag(number_of_frames - five_percent: number_of_frames) = 0;

gesture_flag2 = zeros(length(gesture_flag), 1);
gesture_flag2(1:end-1) = gesture_flag(2:end);

difference = gesture_flag - gesture_flag2;

start_gestures = find(difference == -1);
end_gestures = find(difference == 1);

gesture_length = end_gestures - start_gestures + 1;
start_gestures(gesture_length < parameters.min_gesture_length) = [];
end_gestures(gesture_length < parameters.min_gesture_length) = [];

start_resting = [1, end_gestures' + 1];
end_resting = [start_gestures' - 1, number_of_frames];
resting_length = end_resting - start_resting + 1;
start_resting(resting_length <= parameters.min_resting_length) = [];
end_resting(resting_length <= parameters.min_resting_length) = [];

gestures = zeros( length(start_resting) - 1, 2);
gestures(:, 1) = end_resting(1:end - 1)' + 1;
gestures(:, 2) = start_resting(2:end)' - 1;


% gestures = zeros( length(start_gestures), 2);
% gestures(:, 1) = start_gestures;
% gestures(:, 2) = end_gestures;




end