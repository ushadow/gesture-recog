function [unnormalized, starts, lengths] = update_dtw_scores(previous_unnormalized, previous_starts, ...
                                                             previous_lengths, frame_scores, frame)

% function [unnormalized, starts, lengths] = update_dtw_scores(previous_unnormalized, previous_starts, ...
%                                                              previous_lengths, frame_scores, frame)

number_of_models = numel(previous_unnormalized);

unnormalized = previous_unnormalized;
starts = previous_starts;
lengths = previous_lengths;

for model_index = 1: number_of_models
  model_frame_scores = frame_scores{model_index};
  model_frames = numel(model_frame_scores);
  unnormalized{model_index}(1) = inf;
  
  for first_counter = 1:model_frames
    current_cost = model_frame_scores(first_counter);
    top = unnormalized{model_index}(first_counter);
    left = previous_unnormalized{model_index}(first_counter+1);
    top_left = previous_unnormalized{model_index}(first_counter);
    smallest = min([top; left; top_left]);
    unnormalized{model_index}(first_counter+1) = smallest + current_cost;

    if (top_left == smallest)
      starts{model_index}(first_counter+1) = previous_starts{model_index}(first_counter);
      lengths{model_index}(first_counter+1) = previous_lengths{model_index}(first_counter) + 1;
    elseif (top == smallest)
      starts{model_index}(first_counter+1) = starts{model_index}(first_counter);
      lengths{model_index}(first_counter+1) = lengths{model_index}(first_counter) + 1;
    elseif (left == smallest)
      starts{model_index}(first_counter+1) = previous_starts{model_index}(first_counter+1);
      lengths{model_index}(first_counter+1) = previous_lengths{model_index}(first_counter+1) + 1;
    end
  end
end

