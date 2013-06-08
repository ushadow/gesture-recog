function predicted_labels = measure_accuracy_20110806(dataset_name)

preprocess_training(dataset_name);
dataset = load_dataset(dataset_name);
ground_truth = dataset.test.class_ids;
dataset.spotting_threshold = 0.75;
dataset.wait_frames = 10;
test_size = numel (dataset. test.filenames);

accuracy_file = accuracy_filename(dataset_name);
if (exist(accuracy_file) == 2)
  load(accuracy_file);
  display_accuracy_statistics (predicted_labels, ground_truth);
  return;
end
  
tic;
preprocess_training(dataset_name);
toc;
disp('preprocessed training');

predicted_labels = cell (test_size, 1);
gesture_starts = cell (test_size, 1);
gesture_finishes = cell (test_size, 1);

for test_index = 1:test_size
%  test_sequence = get_frames(dataset, 'te', test_index);
%  frame_scores = all_frame_scores(test_sequence, dataset);

  frame_scores = load_or_compute_frame_scores(dataset, test_index);
  [labels, starts, finishes] = spot_gestures(frame_scores, dataset, 'batch_dtw_motion');
  predicted_labels {test_index} = labels;
  gesture_stars {test_index} = starts;
  gesture_finishes {test_index} = finishes;
  disp(sprintf('processed test sequence %d of %d', test_index, test_size));
end
  
display_accuracy_statistics (dataset, predicted_labels, ground_truth);

