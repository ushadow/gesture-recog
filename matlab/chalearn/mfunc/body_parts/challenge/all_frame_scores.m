function frame_scores = all_frame_scores(test_sequence, dataset)

% function frame_scores = all_frame_scores(test_sequence, dataset)
%
% frame_scores{j}(i, m) is the normalized crosscorrelation score between 
% the motion  image computed for the i-th frame of the m-th model and the
% j-th frame of the test sequence.

input_frames = numel(test_sequence);
model_vertical = size(dataset.models{1}{1}, 1);
model_horizontal = size (dataset.models{1}{1},  2);

preliminary_input_motion = motion_sequence(test_sequence);

% note that we do not need  the number of frames in input_motiont to be
% equal to parameters.frames (it would actually be a bug if we did that)
input_motion = normalize_motion_sequence(preliminary_input_motion, input_frames,  ...
                                         model_vertical, model_horizontal, dataset.parameters.threshold);

number_of_models = numel (dataset.models);
frame_scores = cell(input_frames, 1);

for counter = 1: number_of_models
  model_scores = correlation_scores(dataset.models{counter},  input_motion);
  for j = 1:input_frames
    frame_scores{j}(:, counter) = model_scores(:, j);
  end
end


