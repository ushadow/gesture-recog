function result = compute_current_frame_scores(depth_image, last_frame_features, model, parameters)

% function result = compute_current_frame_scores(depth_image, last_frame_features, dataset, parameters)
global debug;

models = model.T;
number_of_models = numel(models);
current_frame = last_frame_features.frame + 1;

previous_tracking_info = last_frame_features.tracking_info;
[result_image, current_tracking_info] = find_hand_initial2(depth_image, previous_tracking_info, parameters);
if debug
     figure(1); imshow(result_image/255);
end
current_tracking_info = postprocess_tracking_info(current_tracking_info, parameters);

result.tracking_info = current_tracking_info;
result.frame = current_frame;

if (numel(current_tracking_info.hand_info.right_position) == 0)
  result.frame_scores = [];
  return;
end

frame_scores = cell(number_of_models, 1);
for counter = 1:number_of_models
  right_model = models{counter}.hands.right_centered;
  number_of_frames = size(right_model, 1);
  current_scores = zeros(number_of_frames, 1);
  
  for frame = 1:number_of_frames
    right_model_position = right_model(frame, :);
    diffs = right_model_position - current_tracking_info.hand_info.right_normalized;
    diffs = diffs .* diffs;
    current_scores(frame) = sqrt(sum(diffs));
  end
  
  frame_scores{counter} = current_scores;
end


result.tracking_info = current_tracking_info;
result.frame_scores = frame_scores;
