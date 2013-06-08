function [min_value, best_model, start] = find_best_dtw_score(unnormalized_scores, starts, lengths)

% [min_value, model, start] = find_best_dtw_score(unnormalized_scores, starts, lengths)

min_value = inf;
best_model = -1;
start = -1;

number_of_models = numel(unnormalized_scores);
normalized_scores = zeros(number_of_models, 1);

for model = 1:number_of_models
  number_of_frames = numel(unnormalized_scores{model}) - 1;
  unnormalized_score = unnormalized_scores{model}(number_of_frames+1);
  length = lengths{model}(number_of_frames+1);
  normalized_scores(model) = unnormalized_score / length;
  if (normalized_scores(model) < min_value)
    min_value = normalized_scores(model);
    best_model = model;
    start = starts{model}(number_of_frames+1);
  end
end



    
    
