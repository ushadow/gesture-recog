function [realStart, realEnd] = realstartendinpath(path, nSMap, ...
                                subsampleFactor)
%% REALSTARTENDINPATH finds the actual start and end of a gesture

realStart = -1;
realEnd = -1;
if computetransitions(path) <= 3, return; end
  
stageNDX = gesturestagendx(nSMap);
gestureNdx = find(path >= stageNDX(2, 1) & path <= stageNDX(2, 2));
if ~isempty(gestureNdx)
  runs = contiguousindex(gestureNdx);
  nruns = size(runs, 1);
  realStart = runs(1, 1);
  realEnd = runs(1, 2);
  if nruns > 1 && runs(2, 1) - realEnd < 40 / subsampleFactor
      realEnd = runs(2, 2);
  end
  nucleus = path(realStart : realEnd);
  lastStage = contiguous(nucleus, nucleus(end));
  realEnd = realStart + ceil(mean(lastStage{1, 2}(end, :))) - 1;
end
end

