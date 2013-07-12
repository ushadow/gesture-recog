function Y = addFlabel(Y)
for i = 1 : numel(Y)
  seq = Y{i};
  for j = 1 : size(seq, 2) - 1
    if seq(1, j) ~= seq(1, j + 1)
      seq(2, j) = 2;
    else 
      seq(2, j) = 1;
    end
  end
  seq(2, end) = 2;
  Y{i} = seq;
end