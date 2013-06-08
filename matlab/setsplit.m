function data = setsplit(data)
split = cell(3, 1);
nseq = size(data.Y, 2);
split{1, 1} = 1 : nseq - 2;
split{2, 1} = nseq - 1 : nseq;
data.split = split;
end