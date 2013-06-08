function result = do_sanity_checks(dataset)

% function result =  do_sanity_checks(dataset)

% there should be at least two classes

class_ids = dataset.training.class_ids;
number_of_classes = numel (class_ids);
if (number_of_classes <2)
  error ('error, number of classes in dataset = %d, should be >= 2', number_of_classes);
end
  
% there should be at least one test video

test_size = numel (dataset.test.filenames);
if (test_size < 1)
  error ('error, number of test sequences in dataset = %d', test_size);
end

% there should be one and only one training example per class

for counter = 1:number_of_classes
  occurrences = sum(class_ids == counter);
  if (numel (occurrences) ~= 1)
    error('error, number of occurrences for class %d is not 1', counter);
  end
end

% each test video should have at least one gesture present

for counter = 1: test_size
  number_of_gestures = numel (dataset.test.class_ids {counter});
  if (number_of_gestures < 1)
    error ('error, number of gestures in test sequence %d is %d', counter, number_of_gestures); 
  end
end

result = 1;
