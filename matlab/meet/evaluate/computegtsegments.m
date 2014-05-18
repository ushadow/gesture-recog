function segByClass = computegtsegments(Y, restLabel)
ndx = find(Y(2, :) == 2);
startNdx = 1;
segByClass = cell(1, restLabel - 1);
for j = 1 : length(ndx)
  endNdx = ndx(j);
  gestureLabel = Y(1, endNdx);
  if gestureLabel < restLabel
    segByClass{gestureLabel} = [segByClass{gestureLabel}; [startNdx endNdx]];
  end
  startNdx = endNdx + 1;
end
end