function split = leaveoneuseroutsplit(data)
nuser = length(data);
nseq = cellfun(@(x) size(x.X, 2), data);
totalNSeq = sum(nseq);
split = cell(3, nuser);
baseNDX = 0;
for i = 1 : nuser
  split{2, i} = baseNDX + 1 : baseNDX + nseq(i);
  split{1, i} = setdiff(1 : totalNSeq, split{2, i});
  baseNDX = baseNDX + nseq(i);
end