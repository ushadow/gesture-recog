function [insertions, deletions, substitutions, matched] = compare_labels(predicted, true)

% [insertions, deletions, substitutions, matched] = compare_labels(predicted, true)

first = predicted;
second = true;

first_length = numel (first);
second_length = numel (second);

scores = zeros(first_length+1, second_length+1);
backtracking  = zeros (first_length+1, second_length+1);

% backtracking conventions:
% '.' means match and move from top left
% 's' means substitution and move from top left
% 't' means gap and move from top
% 'l' means gap and move from left

% initialize scores and backtracking(:, 1)
scores(:,1) = 0:first_length;
backtracking(:,1) = 't';

for  second_counter =  1: second_length
    % initialize scores and backtracking(1, second_counter)
    scores(1, second_counter+1) = second_counter;
    backtracking(1, second_counter+1) = 'l';
    
    % main loop
    for first_counter = 1:first_length
        current_cost = letter_cost(first(first_counter), second (second_counter));

        top = scores (first_counter, second_counter+1) + 1;
        left = scores (first_counter+1, second_counter) + 1;
        top_left = scores (first_counter, second_counter) + current_cost;
        smallest = min([top; left; top_left]);
        scores (first_counter+1, second_counter+1) = smallest;
        
        if (top_left == smallest)
            if (current_cost == 0)
                backtracking (first_counter+1, second_counter+1) = '.';
            else
                backtracking (first_counter+1, second_counter+1) = 's';
            end
        elseif (top == smallest)
            backtracking(first_counter+1, second_counter+1) = 't';
        elseif (left == smallest)
            backtracking(first_counter+1, second_counter+1) = 'l';
        end
    end
end

result = scores(first_length+1, second_length+1);

path = backtracking_path(backtracking);
%disp(sprintf('the path length is %d', numel(path)));
%disp(sprintf('%c ', path));

%print_alignment (first, second, path);

insertions = numel(strfind(path, 't'));
deletions = numel(strfind(path, 'l'));
substitutions = numel(strfind(path, 's'));
matched = numel(strfind(path, '.'));

