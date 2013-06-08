function models = preprocess_training(recognizer, data)

parameters = recognizer.parameters;
number = data.vocabulary_size;
models = cell(number, 1);

for i = 1:number
  fprintf('processing %d of %d', i, number);
  depth_frames = get_depth_frames(data, i);
  hand_trajectories = find_hands_in_sequence(depth_frames, parameters);
  models{i}.hands = hand_trajectories;
end

% models_name = models_filename(dataset_name);
% save(models_name, 'models', 'parameters');


