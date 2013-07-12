function checkdata(data)
for j = 1 : numel(data.Y)
  seq = data.Y{j};
  for i = 1 : size(seq, 2) - 1
    if seq(1, i) ~= seq(1, i + 1)
      assert(seq(2, i) == 2);
    else
      assert(seq(2, i) == 1);
    end
  end
  assert(seq(2, end) == 2);
end