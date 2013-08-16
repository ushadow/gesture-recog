function [prior, transmat, term] = makeposttrans(nS)
if nS == 3
  [prior, transmat, term] = makepretrans(nS);
end
end