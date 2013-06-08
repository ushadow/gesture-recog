function result = normalize_dtw_scores(scores, lengths)

% function result = normalize_dtw_scores(scores, lengths)
%
% scores(i, j) is the score  obtained for the i-th model and the j-th frame
% of the input sequence.
% lengths(i, j) is the length of the warping path whose cost is stored in 
% scores(i, j)
%
% result(i, j) = scores(i, j) / lengths(i, j)

result = scores ./ lengths;
