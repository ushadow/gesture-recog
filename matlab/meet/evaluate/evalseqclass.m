function stat = evalseqclass(Ytrue, Ystar, ~)
% EVALSEQCLASS evaluates the classification as a sequence not by frame.
% Args:
% - Ytrue: a cell array.
% - Ystar: a cell array.
trueLabel = frame2event(Ytrue);
actualLabel = frame2event(Ystar);
stat = edit_distance_levenshtein(trueLabel, actualLabel);
end

function event = frame2event(seq)
prevlabel = seq{1, 1};
event = prevlabel;
for i = 2 : size(seq, 2)
  label = seq{1, i};
  if label ~= prevLabel
    event(end + 1) = label; %#ok<AGROW>
    prevLabel = label;
  end
end
end