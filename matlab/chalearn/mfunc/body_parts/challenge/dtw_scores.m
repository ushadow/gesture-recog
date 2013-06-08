function [scores, start_frames, path_lengths] = dtw_scores(frame_scores)

% function [scores, start_frames, path_lengths] = dtw_scores(frame_scores)
%
% computes the dtw distance between two sequences, assuming that
% pairwise frame-by-frame scores have already been computed and stored at the 
% frame_scores matrix.
% it does subsequence matching, and it is NOT memory efficient
% 
% at the end, scores(frame) is the cost of the optimal path ending at that
% particular test frame, and start_frames(frame) is the start frame
% corresponding  to that optimal path.
% path_lengths(frame) is the length of the optimal path ending at that
% particular test frame.

first_length = size(frame_scores, 1);
second_length = size(frame_scores, 2);

scores = zeros(first_length+1, second_length+1);
start_frames  = zeros (first_length+1, second_length+1);

% initialize scores and start_frames(:, 1)
scores(:,1) = inf;
start_frames(:,1) = -1; % an invalid value, on purpose
path_lengths(:,1) = -1; % an invalid value, on purpose

for  second_counter =  1: second_length
  start_frames(1, second_counter+1) = second_counter;
  path_lengths(1, second_counter+1) = 0; % an invalid character, on purpose

  % main loop
  for first_counter = 1:first_length
    current_cost = frame_scores(first_counter, second_counter);
    top = scores (first_counter, second_counter+1);
    left = scores (first_counter+1, second_counter);
    top_left = scores (first_counter, second_counter);
    smallest = min([top; left; top_left]);
    scores (first_counter+1, second_counter+1) = smallest + current_cost;

    if (top_left == smallest)
      start_frames (first_counter+1, second_counter+1) = start_frames(first_counter, second_counter);
      path_lengths(first_counter+1, second_counter+1) = path_lengths(first_counter, second_counter) + 1;
    elseif (top == smallest)
      start_frames(first_counter+1, second_counter+1) = start_frames(first_counter, second_counter+1);
      path_lengths(first_counter+1, second_counter+1) = path_lengths(first_counter, second_counter+1)+1;
    elseif (left == smallest)
      start_frames(first_counter+1, second_counter+1) = start_frames(first_counter+1, second_counter);
      path_lengths(first_counter+1, second_counter+1) = path_lengths(first_counter+1, second_counter)+1;
    end
  end
end

% keep only the last row of the results

scores = scores(first_length+1, 2:(second_length+1));
start_frames = start_frames(first_length+1, 2:(second_length+1));
path_lengths = path_lengths(first_length+1, 2:(second_length+1));
