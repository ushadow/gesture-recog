function [labels, gesture_starts, gesture_finishes] = ...
  spot_gestures(test_sequence, model, segment_interval);

% function [labels, gesture_starts, gesture_finishes] = ...
%   spot_gestures(test_sequence, dataset, parameters);

parameters = model.parameters;

% models = dataset.models;
models = model.T;
number_of_models = numel(models);
number_of_frames = numel(test_sequence);

labels = zeros(number_of_frames, 1);
gesture_starts = zeros(number_of_frames, 1);
gesture_finishes = zeros(number_of_frames, 1);
label_index = 0;

% 'waiting' means we are waiting for a gesture to start, 'observing' means we are observing a gesture.
current_mode = 'waiting'; 
current_features.frame = 0;
current_features.tracking_info = initial_tracking_info(double(test_sequence{1}), parameters);
% disp(sprintf('%d frames\n', number_of_frames));
gesture_interval = zeros(number_of_frames, 1);
for i=1:size(segment_interval)
   gesture_interval( segment_interval(i,1) : segment_interval(i,2) ) = 1; 
end
% tic;
for frame = 1:number_of_frames
%  disp(sprintf('processing frame %d of %d\n', frame, number_of_frames));

  last_features = current_features;
  current_features = compute_current_frame_scores(test_sequence{frame}, last_features, model, parameters);
  
  if (numel(current_features.frame_scores) ~= 0)
%    if ( gesture_interval(frame) == 1)
        if (strcmp(current_mode, 'waiting')) % we found the first frame of a gesture
          % reset the dynamic programming columns, and other variables
          [current_unnormalized, current_starts, current_lengths] = initialize_dp_tables(models, frame);
          current_mode = 'looking';
        elseif (strcmp(current_mode, 'looking' == 0))
          error('unknown mode %s', current_mode);
        end
    
%         if (numel(current_features.frame_scores) ~= 0)
            previous_unnormalized = current_unnormalized;
            previous_starts = current_starts;
            previous_lengths = current_lengths;
            [current_unnormalized, current_starts, current_lengths] = update_dtw_scores(previous_unnormalized, previous_starts, ...
                                                                                    previous_lengths, current_features.frame_scores, frame);
%         end
  else %if (numel(current_features.frame_scores) == 0)
    if (strcmp(current_mode, 'waiting')) % waiting for a gesture to start
      continue;
    elseif (strcmp(current_mode, 'looking' == 0))
      error('unknown mode %s', current_mode);
    end
    
    % here is a frame where we found no hands, whereas in the previous
    % frame we did. This indicates the end of a gesture.
    
    [min_value, model_index, start] = find_best_dtw_score(current_unnormalized, current_starts, current_lengths);
%     if (model_index == -1)
%         model_index = 1;
%     end
    
    % if we fail to detect the hand, but we are far from  a neutral
    % position, we should not consider this as the end of a gesture
%     disp(sprintf('last hand row: %d', last_features.tracking_info.hand_info.right_position(1)));
%    if (last_features.tracking_info.hand_info.right_position(1) < 400)
%      current_features.tracking_info = last_features.tracking_info;
%      continue;
%    end

    % reject the gesture if it is too short
    length = frame - start;
    if (length >= parameters.min_gesture_length)
      label_index = label_index+1;
      %labels(label_index) = dataset.training.class_ids(model);
      labels(label_index) = models{model_index}.label;
      gesture_starts(label_index)  = start;
      gesture_finishes (label_index) =  frame - 1;
    end
    
    current_mode = 'waiting';
  end
end  
% toc;

labels = labels(1:label_index);
gesture_starts = gesture_starts(1:label_index);
gesture_finishes = gesture_finishes(1:label_index);


