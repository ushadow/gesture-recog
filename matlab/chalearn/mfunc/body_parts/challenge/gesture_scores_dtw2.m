function [global_scores, backtracking] = gesture_scores_dtw2(observed, model, parameters)

% function [global_scores, backtracking] = gesture_scores_dtw(observed, model, parameters)
%
% model is a motion sequence used as training data, and corresponding 
% to a specific gesture, and with
% normalized number of frames, rows, cols
% 
% observed is an input video sequence, where we want to do gesture spotting. 
%
% parameters  is a structure that includes all the parameters needed to
% calculate the scores.
%
% the method we use here uses DTW for global alignment, and UNNORMALIZED correlation of
% motion differences for the frame to frame matching score

model_frames =  numel (model);
model_vertical = size(model{1}, 1);
model_horizontal = size (model {1},  2);
 
input_frames = numel (observed);
preliminary_input_motion = motion_sequence (observed);

% note that we do not need  the number of frames in input_motiont to be
% equal to parameters.frames (it would actually be a bug if we did that)
input_motion = normalize_motion_sequence(preliminary_input_motion, input_frames,  ...
                                         model_vertical, model_horizontal, parameters.threshold);

frame_scores = correlation_scores (model,  input_motion);

% note that my DTW algorithm implementation tries to minimize costs 
% and assumes that all costs  are nonnegative. On the other hand, in frame_scores
% high values indicate better matching, so we need to preprocess those
% course before we pass them to DTW.

max_value = max(frame_scores(:));
adjusted_scores = max_value-frame_scores;
[global_scores, backtracking]  = dtw_scores(adjusted_scores);

