function stageNDX = gesturestagendx(nSMap)
nstages = length(nSMap);
stageNDX = zeros(nstages, 2);
stageNDX(1, :) = [1, nSMap(1)];
for i = 2 : nstages
  baseNDX = stageNDX(i - 1, 2);
  stageNDX(i, :) = [baseNDX + 1, baseNDX + nSMap(i)];
end
end