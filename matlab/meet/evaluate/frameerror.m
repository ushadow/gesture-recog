function error = frameerror(Ytrue, Ystar, ~)
% ERRORPERFRAME total number of gesture label errors for all the frame for 
%               each variable.
% 
% ARGS
% Ytrue   - cell array of true labels.
% Ystar   - predicted labels in a sequence.
% 
% Returns:
% - error: number of errors.
% - n: total number of frames in the sequence.

sum = 0;
nseq = numel(Ytrue);
for i = 1 : nseq
  score = frameerror1(Ytrue{i}, Ystar{i});
  sum = sum + score;
end
error = sum / nseq;
end

function error = frameerror1(Ytrue, Ystar)
error = sum(1 - (Ytrue(1, :) == Ystar(1, :)), 2);
n = size(Ytrue, 2);
error = error / n;
end
