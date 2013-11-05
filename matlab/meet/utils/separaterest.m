function [rest, gesture] = separaterest(Y, X, restNDX)
%% SEPARATEREST 

nseqs = size(Y, 2);
rest = cell(1, nseqs);
gesture = cell(1, nseqs);
for i = 1 : nseqs
  seqY = Y{i};
  seqX = X{i};
  ndx = seqY(1, :) == restNDX;
  rest{i} = seqX(:, ndx);
  gesture{i} = seqX(:, ~ndx);
end

rest = cell2mat(rest);
gesture = cell2mat(gesture);
end