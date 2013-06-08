function class_ids = read_truth_labels(dataset_name, vocabulary)


filename = 'valid_ground_truth.txt';
number_of_classes = numel(vocabulary);
test_size = 47 - number_of_classes;


class_ids = cell(test_size, 1);

fid = fopen(filename, 'r');
% for counter = 1:number_of_classes
%   next = fgetl(fid);
% end
next = '';
while ( isempty(regexp(next, dataset_name, 'once') ) )
    next = fgetl(fid);
end
  
for counter = 1:test_size


 
  number_of_gestures = sum(next==' ') + 1;
  class_ids{counter} = zeros(number_of_gestures, 1);
  [token remain] = strtok(next, ',');
  
  counter2 = 1;
  while (~isempty(remain))
        [token remain] = strtok(remain, ', ');
        class_ids{counter}(counter2) = sscanf(token, '%d');
        counter2 = counter2 + 1;
  end

 
   next = fgetl(fid);
end

fclose(fid);


