function [newY, newX] = segmentbyrest(Y, X, restNDX)
%% SEGMENTBYREST segment the sequences by rest positions.
%
% RETURNS
% newY  - cell array of label sequences. Each cell is a 1xn matrix.

nSeqs = size(Y, 2);
newX = {};
newY = {};
for i = 1 : nSeqs
  seqY = Y{i}(1, :);
  seqX = X{i};
  ndx = seqY ~= restNDX;
  runs = contiguous(ndx, 1);
  runs = runs{1, 2};
  for j = 1 : size(runs, 1)
    run = runs(j, :);
    newX{end + 1} = seqX(:, run(1) : run(2)); %#ok<AGROW>
    newY{end + 1} = seqY(run(1) : run(2)); %#ok<AGROW>
  end
end
end