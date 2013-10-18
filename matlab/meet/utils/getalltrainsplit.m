function split = getalltrainsplit(data)
%% GETALLTRAINSPLIT creates a training and testing split that uses all 
% data for training
%
% ARGS
% data  - struct of MEET data.

nseq = size(data.Y, 2);
split = {1 : nseq; []; []};
end