function label = labelseq(frameseq)
label = frameseq(1, 1);
for i = 2 : size(frameseq, 2)
  if frameseq(1, i) ~= label(end)
    label(end + 1) = frameseq(1, i); %#ok<AGROW>
  end
end
end