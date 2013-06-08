function [labels, gesture_starts, gesture_finishes] = spot_gestures(scores, start_frames, threshold, dataset);

% [labels, gesture_starts, gesture_finishes] = spot_gestures(scores, start_frames, threshold, model_labels);
%
% model_labels(i) is the class label of the i-th model

number_of_models = size(scores, 1);
number_of_frames = size(scores, 2);

labels = zeros(number_of_frames, 1);
gesture_starts = zeros(number_of_frames, 1);
gesture_finishes = zeros(number_of_frames, 1);
label_index = 0;

% last_finish will store  the last frame  of the last gesture we have
% recognized
last_finish = 0;
frame = 0;

while (frame < number_of_frames)
  frame = frame+1;
  current_scores =  scores (:, frame);
  current_starts = start_frames(:, frame);
  current_scores(current_starts <= last_finish) = inf;
  [best_score, best_model] = min(current_scores);
  if (best_score > threshold)
    continue;
  end
  
  % if we get here, we have found a frame  where  for  one of the models we
  % got an acceptable score.
  % now we need to continue as long as the score keeps improving.
  current_finish = frame;
  current_best_score = best_score;
  current_best_model = best_model;
  while(1)
    frame = frame + 1;
    if (frame > number_of_frames)
      break;
    end
    
    current_scores =  scores (:, frame);
    current_starts = start_frames(:, frame);
    current_scores(current_starts <= last_finish) = inf;
    [best_score, best_model] = min(current_scores);
    if (best_score > current_best_score)
      break;
    end
    
    current_finish = frame;
    current_best_score = best_score;
    current_best_model = best_model;
  end

  % at this point we found the end frame for the gesture.
  label_index = label_index + 1;
  labels (label_index) =  dataset.training.class_ids(current_best_model);
  gesture_starts(label_index)  = start_frames (current_best_model, frame);
  gesture_finishes (label_index) =  frame;
  last_finish = frame;
end

labels = labels(1:label_index);
gesture_starts = gesture_starts(1:label_index);
gesture_finishes = gesture_finishes(1:label_index);


