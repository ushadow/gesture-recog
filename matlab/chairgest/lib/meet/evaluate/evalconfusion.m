function cm = evalconfusion(batchData, batchRes, nmodel, nfold)
%
% ARGS
% batchData - cell array of all data.
% batchRes  - cell array of all results.

nbatch = numel(batchData);
batchRes = groupres(batchRes, nbatch, nmodel, nfold); 

cm = zeros(13, 13);
for i = 1 : nbatch
  Y = batchData{i}.Y;
  R = batchRes{i};
  nfold = size(R, 2);
  for j = 1 : nfold
    split = R{j}.split;
    Ytrue = Y(split{2});
    cm = evalOneFold(Ytrue, R{j}.prediction.Va, cm);
  end
end
total = sum(cm, 2);
total = repmat(total(:), 1, size(cm, 2));
cm = round(cm * 100 ./ total);
end

function cm = evalOneFold(Ytrue, Ystar, cm)
% - Ytrue: cell arrary of sequences.
for i = 1 : length(Ytrue)
  for j = 1 : size(Ytrue{i}, 2)
    cm(Ytrue{i}(1, j), Ystar{i}(1, j)) = cm(Ytrue{i}(1, j), Ystar{i}(1, j)) + 1; 
  end
end
end