function [unnormalized, starts, lengths] = initialize_dp_tables(models, frame)

% function [unnormalized, starts, lengths] = initialize_dp_tables(models, frame)

number_of_models = numel(models);
unnormalized = cell(number_of_models, 1);
starts = cell(number_of_models, 1);
lengths = cell(number_of_models, 1);

for counter = 1:number_of_models
  model_frames = size(models{counter}.hands.right_centered, 1);
  unnormalized{counter} = zeros(model_frames+1, 1) + inf;
  unnormalized{counter}(1) = 0;
  starts{counter} = zeros(model_frames+1, 1) + frame;
  lengths{counter} = zeros(model_frames+1, 1);
end
