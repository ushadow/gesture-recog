function cm = evalconfusion(batchData, batchRes, nModels, nFolds, param)
%
% ARGS
% batchData - cell array of all data in batches.
% batchRes  - cell array of all results from experiment run.
% nModels   - number of hyper parameter models
% nFolds    - number of evaluation folds. 

nbatch = numel(batchData);
batchRes = groupres(batchRes, nbatch, nModels, nFolds); 
vocabSize = param.vocabularySize;
prePostMargin = param.prePostMargin;

cm = zeros(vocabSize, vocabSize);
for i = 1 : nbatch
  Y = batchData{i}.Y;
  R = batchRes{i};
  nFolds = size(R, 2);
  for j = 1 : nFolds
    split = R{j}.split;
    Ytrue = Y(split{2});
    cm = evalOneFold(Ytrue, R{j}.prediction.Va, cm, vocabSize, param.prePostMargin);
  end
end
total = sum(cm, 2);
total = repmat(total(:), 1, size(cm, 2));
cm = cm * 100 ./ total;
end

function cm = evalOneFold(YtrueAll, YstarAll, cm, vocabSize, prePostMargin)
% - Ytrue: cell arrary of sequences.

restLabel = vocabSize;

for n = 1 : length(YtrueAll)
  Ytrue = YtrueAll{n};
  Ystar = YstarAll{n};
  events = computegtsegments(Ytrue, vocabSize);
  
  for i = 1 : length(events)
    if i < restLabel
      runs = events{i};
      for j = 1 : size(runs, 1)
        startNdx = runs(j, 1);
        endNdx = runs(j, 2);
        % Remove the first 15 frames and last 15 frames because they may be
        % pre and post strokes
        Ytrue(1, startNdx : min(endNdx, startNdx + prePostMargin)) = restLabel;
        Ystar(1, startNdx : min(endNdx, startNdx + prePostMargin)) = restLabel;
        Ytrue(1, max(startNdx, endNdx - prePostMargin : endNdx)) = restLabel;
        Ystar(1, max(startNdx, endNdx - prePostMargin : endNdx)) = restLabel;
      end
    end
  end

  for j = 1 : size(Ytrue, 2)
    if (Ytrue(1, j) <= vocabSize)
     cm(Ytrue(1, j), Ystar(1, j)) = cm(Ytrue(1, j), Ystar(1, j)) + 1; 
    end
  end
end
end