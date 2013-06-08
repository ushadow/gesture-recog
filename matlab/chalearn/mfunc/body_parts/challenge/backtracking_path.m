function result = backtracking_path(backtracking)

% function result = backtracking_path (backtracking)
%
% this is an auxiliary function used by detailed_edit_distance.
% it is passed in as input the backtracking matrix computed by the edit
% distance function.
%
% the result is simply a sequence (in temporal order) of the characters in
% the backtracking matrix that correspond to the optimal warping path

first_length = size(backtracking, 1) - 1;
second_length = size(backtracking, 2) - 1;

temporary_result = zeros (first_length + second_length, 1);

current_vertical = first_length+1;
current_horizontal = second_length+1;
current_index = 1;

while ((current_horizontal ~= 1) | ( current_vertical ~= 1))
    current = backtracking (current_vertical, current_horizontal);
    temporary_result (current_index) = current;
    if (current == '.') | (current == 's')
        previous_vertical = current_vertical -1;
        previous_horizontal =  current_horizontal -1;
    elseif current == 't'
        previous_vertical = current_vertical -1;
        previous_horizontal =  current_horizontal;
    elseif current == 'l'
        previous_vertical = current_vertical;
        previous_horizontal =  current_horizontal-1;
    else
        error('error: unrecognized character  in backtracking matrix');
    end
    
    current_index = current_index +1;
    current_vertical = previous_vertical;
    current_horizontal = previous_horizontal;
end

result = temporary_result((current_index-1):-1:1);
result = result';
