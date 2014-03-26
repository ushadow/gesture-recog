function res = readunscaledimage(filename)
fd = fopen(filename);
fgets(fd);
res = {};
imageStartNdx = 7;

while ~feof(fd)
  line = fgets(fd);
  tokens = strsplit(line, ',');
  num = cellfun(@(x) str2double(x), tokens(1 : end - 1));
  width = num(5);
  image = reshape(num(imageStartNdx : end), width, width)';
  res{end + 1} = mat2gray(image); %#ok<AGROW>
end
fclose(fd);
end