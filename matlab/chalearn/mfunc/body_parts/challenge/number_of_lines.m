function result = number_of_lines(filename)

result = 0;
fid = fopen(filename);

while (1)
  next = fgetl(fid);
  if (next(1) == -1)
    break;
  end
  result = result + 1;
end

fclose(fid);
