function result = load_or_compute_frame_scores(dataset, number)

% function result = get_frames(dataset, subset, number)
%
% dataset is a result of calling function make_dataset
% subset is 'tr' or 'te' for training or test set
% number is the index of the video we want to read

filename = dataset.test.filenames{number};
scores_file = frame_scores_filename(filename);
if (exist(scores_file, 'file') == 2)
  load(scores_file);
  result = frame_scores;
  return;
end

mov = aviread(filename);
test_sequence = extract_field(mov, 'cdata');

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

save(scores_file, 'frame_scores');
result = frame_scores;



