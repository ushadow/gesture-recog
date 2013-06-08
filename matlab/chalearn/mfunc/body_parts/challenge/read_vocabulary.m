function result = read_vocabulary(dataset_name)

% function result = read_vocabulary(dataset_name)

name = vocabulary_filename(dataset_name);
lines = number_of_lines(name);

result = cell(lines, 1);

fid = fopen(name, 'r');
for counter = 1:lines
  result{counter} = fgetl(fid);
end

fclose(fid);

