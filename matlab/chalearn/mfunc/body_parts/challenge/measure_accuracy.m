function predicted_labels = measure_accuracy(recognizer, data)

parameters = recognizer.parameters;
  
dataset = load_dataset(dataset_name);
if (isfield(dataset, 'models') == 0)
  tic; dataset.models = preprocess_training(dataset_name, parameters); toc;
  disp('preprocessed training');
end

ground_truth = read_truth_labels(dataset_name, dataset.vocabulary);

accuracy_file = accuracy_filename(dataset_name);
if (exist(accuracy_file) == 2)
  load(accuracy_file);
  display_accuracy_statistics(predicted_labels, ground_truth);
  return;
end
  

predicted_labels = cell (test_size, 1);
gesture_starts = cell (test_size, 1);
gesture_finishes = cell (test_size, 1);

for test_index = 1:test_size
  depth_frames = get_depth_frames(dataset, 'te', test_index);
  [labels, starts, finishes] = spot_gestures(depth_frames, dataset, parameters);
  
  predicted_labels{test_index} = labels;
  gesture_starts {test_index} = starts;
  gesture_finishes {test_index} = finishes;
  fprintf('processed test sequence %d of %d', test_index, test_size);
end

save(sprintf('%s_result.mat', dataset_name), 'predicted_labels', 'gesture_starts', 'gesture_finishes');

%load(sprintf('%s_result.mat', dataset_name));  
display_accuracy_statistics (dataset, predicted_labels, ground_truth);

