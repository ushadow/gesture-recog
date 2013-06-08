function result =  letter_cost(first, second)

% function result =  letter_cost(first, second)
%
% computes the cost (under the edit distance) of matching the two letters
% given as input arguments. 
%
% There is also a letter_score function, to be used with Smith-Waterman

if first == second
    result = 0;
else result = 1;
end

