function ldcrf = trainldcrfwrap(Y, X, param)

ldcrfParam.nbHiddenStates = param.nS;
ldcrfParam.optimizer = 'lbfgs';
ldcrfParam.regFactorL2 = param.regFactorL2;
ldcrfParam.windowSize = 0;
ldcrfParam.debugLevel = 0;
ldcrfParam.maxIterations = param.maxIter;
ldcrfParam.modelType = 'ldcrf';
ldcrfParam.caption = 'LDCRF';

restNDX = param.vocabularySize;
[labels, seqs] = segmentprepost(Y, X, restNDX);
% Labels to LDCRF are zero-based.
labels = cellfun(@(x) x - 1, labels, 'UniformOutput', false);
ldcrf.model = trainLDCRF(seqs, labels, ldcrfParam);
ldcrf.param = ldcrfParam;
ldcrf.segment = trainsegment(Y, X, restNDX, param.nRest);
end

function [newY, newX] = segmentprepost(Y, X, restNdx)
nSeq = size(Y, 2);
newX = {};
newY = {};
nGesture = restNdx - 3;
for i = 1 : nSeq
  seqY = Y{i}(1, :);
  seqX = X{i};
  ndx = seqY ~= restNdx;
  runs = contiguous(ndx, 1);
  runs = runs{1, 2};
  for j = 1 : size(runs, 1)
    run = runs(j, :);
    newX{end + 1} = seqX(:, run(1) : run(2)); %#ok<AGROW>
    label = seqY(run(1) : run(2)); 
    I = find(label <= nGesture);
    gestureLabel = label(I(1));
    label(label == nGesture + 1) = nGesture + (gestureLabel - 1) * 2 + 1;
    label(label == nGesture + 2) = nGesture + gestureLabel * 2;
    newY{end + 1} = label; %#ok<AGROW>
  end
end
end