function data = setsplit(data, testPerc)
%% SETSPLIT sets the training and testing split
%
% ARGS
% data     - struct of MEET data.
% testPerc - percentage of test data.

split = cell(3, 1);
nseq = size(data.Y, 2);
ntest = floor(nseq * testPerc);
split{1, 1} = 1 : nseq - ntest;
split{2, 1} = nseq - ntest + 1 : nseq;
data.split = split;
end