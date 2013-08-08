function outputsvmdata(fid, data, label)
d = size(data, 1);
for i = 1 : size(data, 2)
  fprintf(fid, '%d', label);
  for j = 1 : d
    fprintf(fid, ' %d:%f', j, data(j, i));
  end
  fprintf(fid, '\n');
end
end