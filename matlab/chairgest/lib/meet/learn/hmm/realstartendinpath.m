function [realStart, realEnd] = realstartendinpath(path, nSMap)
realStart = -1;
realEnd = -1;
if computetransitions(path) <= 3, return; end
  
stageNDX = gesturestagendx(nSMap);
gestureNDX = find(path >= stageNDX(2, 1) & path <= stageNDX(2, 2));
if ~isempty(gestureNDX)
  runs = contiguousindex(gestureNDX);
  realStart = runs(1, 1);
  realEnd = runs(1, 2);
  nucleus = path(realStart : realEnd);
  lastStage = contiguous(nucleus, nucleus(end));
  realEnd = realStart + ceil(mean(lastStage{1, 2}(end, :))) - 1;
end
end

function n = computetransitions(path)
  runs = contiguous(path);
  n = 0;
  for i = 1 : size(runs, 1)
    n = n + size(runs{i, 2}, 1);
  end
end