function pred = findnucleus(pred, path, seg, param)

restNdx = param.vocabularySize;
nSMap = param.nSMap;

dataTypes = {'Tr', 'Va'};
for i = 1 : length(dataTypes)
  dataType = dataTypes{i};
  if isfield(pred, dataType)
    pred1 = pred.(dataType);
    seg1 = seg.(dataType);
    path1 = path.(dataType);
    pred.(dataType) = findnucleus1(pred1, path1, seg1, nSMap, restNdx);
  end
end
end

function pred = findnucleus1(pred, path, seg, nSMap, restNdx)
for n = 1 : length(pred)
  pred1 = pred{n};
  seg1 = seg{n};
  path1 = path{n};
  for i = 1 : size(seg1, 1)
    startNdx = seg1(i, 1);
    endNdx = seg1(i, 2);
    pathSeg = path1(startNdx : endNdx);
    [realStart, realEnd] = findinsegment(pathSeg, nSMap);
    if realStart == -1
      pred1(startNdx : endNdx) = restNdx;
    else
      pred1(startNdx : startNdx + realStart - 2) = restNdx - 2;
      pred1(startNdx + realEnd : endNdx) = restNdx - 1;
    end
  end
  pred{n} = pred1;
end
end

function [realStart, realEnd] = findinsegment(path, nSMap)
realStart = -1;
realEnd = -1;
  
stageNdx = gesturestagendx(nSMap);
gestureNdx = find(path >= stageNdx(2, 1) & path <= stageNdx(2, 2));
if ~isempty(gestureNdx)
  runs = contiguousindex(gestureNdx);
  realStart = runs(1, 1);
  realEnd = runs(1, 2);
  nucleus = path(realStart : realEnd);
  lastStage = contiguous(nucleus, nucleus(end));
  realEnd = realStart + ceil(mean(lastStage{1, 2}(end, :))) - 1;
end
end