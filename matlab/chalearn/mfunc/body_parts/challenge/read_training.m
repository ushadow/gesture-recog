function result = read_training(dataset_name, vocabulary)

% function result = read_training(dataset_name, vocabulary)

dirname = dataset_directory(dataset_name);
filename = labels_filename(dataset_name);
number = numel(vocabulary);

class_ids = zeros(number, 1);
filenames = cell(number, 1);

fid = fopen(filename, 'r');
for counter = 1:number
  next = fgetl(fid);
  class_ids(counter) = sscanf(next, '%d');

  file_number = counter;

  possible_filenames = cell(5,1);
  possible_filenames{1} = sprintf('%s/G%d.mat', dirname, file_number);
  possible_filenames{2} = sprintf('%s/G%d_1.mat', dirname, file_number);
  possible_filenames{3} = sprintf('%s/G%d_2.mat', dirname, file_number);
  possible_filenames{4} = sprintf('%s/G%d_3.mat', dirname, file_number);
  possible_filenames{5} = sprintf('%s/K_%d.avi', dirname, file_number);

  found = 0;
  for i = 1:5
    if (exist(possible_filenames{i}) == 2)
      filenames{counter} = possible_filenames{i};
      found = found+1;
    end
  end
  
  % it looks like in some cases there may be multiple files present
  % in those cases, we just pick the first.
  if (found == 0)
    error('no file found for training example %d', counter);
  end
end

fclose(fid);

result.class_ids = class_ids;
result.filenames = filenames;

