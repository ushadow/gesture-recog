function split = getsplit(data, nfold)
%% SETSPLIT sets the training and testing split
%
% ARGS
% data     - struct of MEET data.
% testPerc - percentage of test data.

split = cell(3, nfold);
nseq = size(data.Y, 2);
ntest = floor(nseq / nfold);
for i = 1 : nfold
  split{2, i} = (i - 1) * ntest + (1 : ntest);
  split{1, i} = setdiff(1 : nseq, split{2, i});
end
end