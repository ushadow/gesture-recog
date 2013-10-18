function checkahmmresult(r, G, F)
% CHECKAHMMRESULT checks AHMM invariants.
%
% Args:
% - G: G node index.
% - F: F node index.
if isstruct(r{1})
  for i = 1 : length(r)
    seq = r{i}.prediction.train;
    checkonedatatype(seq, G, F);
    seq = r{i}.prediction.validate;
    checkonedatatype(seq, G, F);
  end
else
  checkoneseq(r, G, F);
end
end

function checkonedatatype(seq, G, F)
for i = 1 : length(seq)
  checkoneseq(seq{i}, G, F);
end
end

function checkoneseq(seq, G, F)
for i = 1 : length(seq)
  if i > 1
    f = seq{F, i - 1};
    if f == 1
      assertTrue(seq{G, i - 1} == seq{G, i});
    else
      assertTrue(f == 2);
    end
  end
end
end