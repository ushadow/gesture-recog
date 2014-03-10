function [rest, gesture] = separaterest(Y, X, restNdx, featureNdx)
%% SEPARATEREST separates rest vs. non-rest frames according to ground truth.

if nargin < 4, featureNdx = 1 : size(X{1}); end

nseqs = size(Y, 2);
rest = cell(1, nseqs);
gesture = cell(1, nseqs);
for i = 1 : nseqs
  seqY = Y{i};
  seqX = X{i};
  ndx = seqY(1, :) == restNdx;
  rest{i} = seqX(featureNdx, ndx);
  gesture{i} = seqX(featureNdx, ~ndx);
end

rest = cell2mat(rest);
gesture = cell2mat(gesture);
end