function label = labelseq(frameseq)
label = frameseq{1};
for i = 2 : length(frameseq)
  if frameseq{i} ~= label(end)
    label(end + 1) = frameseq{i}; %#ok<AGROW>
  end
end
end