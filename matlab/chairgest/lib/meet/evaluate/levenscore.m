function score = levenscore(Ytrue, Ystar, verbose)
% Returns:
% - n: number of labels.

truth = Ytrue(1, Ytrue(2, :) == 2);
pred = labelseq(Ystar(1, :));
score = levenshtein(truth, pred);
n = length(truth);
score = score / n;
if verbose
  if score > 0
    logdebug('levenscore', 'truth', truth);
    logdebug('levenscore', 'pred', pred);
  end
end
end

function label = labelseq(frameseq)
label = frameseq(1);
for i = 2 : length(frameseq)
  if frameseq(i) ~= label(end)
    label(end + 1) = frameseq(i); %#ok<AGROW>
  end
end
end