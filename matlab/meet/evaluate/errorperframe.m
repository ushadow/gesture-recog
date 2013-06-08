function error = errorperframe(Ytrue, Ystar, ~)
% ERRORPERFRAME total number of gesture label errors for all the frame for 
%               each variable.
% 
% Args:
% - Ytrue: true labels in a sequence.
% - Ystar: predicted labels in a sequence.
% 
% Returns:
% - error: number of errors.
% - n: total number of frames in the sequence.

error = sum(1 - (Ytrue(1, :) == Ystar(1, :)), 2);
n = size(Ytrue, 2);
error = error / n;
end
