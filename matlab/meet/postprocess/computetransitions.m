function n = computetransitions(path)
  runs = contiguous(path);
  n = 0;
  for i = 1 : size(runs, 1)
    n = n + size(runs{i, 2}, 1);
  end
end