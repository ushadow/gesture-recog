function result = make_dataset(dataset_name)

% function result = make_dataset(dataset_name)

result.name = dataset_name;
result_directory = dataset_directory(dataset_name);
result.vocabulary = read_vocabulary(dataset_name);
result.training = read_training(dataset_name, result.vocabulary);
%result.test = read_test(dataset_name, result.vocabulary);

% do some sanity checking on the dataset, to make sure that it satisfies
% certain assumptions, such as the assumption that there is one and only one
% training example for each class.

%do_sanity_checks(result);

% file_ids maps every class label in the test set to a number that
% indicates which training example corresponds to that class label.
% this is useful for debugging, as training examples are not ordered based
% on their class labels.

% test_ids = result.test.class_ids;
% test_size = numel(test_ids);
% file_ids = cell(test_size, 1);
% 
% for i = 1:test_size
%   current_ids = test_ids{i};
%   number = numel(current_ids);
%   current_file_ids = zeros(number, 1);
%   
%   for j = 1:number
%     current_id = current_ids(j);
%     file_id = find(result.training.class_ids == current_id);
%     if (numel(file_id) ~= 1)
%       error(sprintf('%d matches found for class id %d', numel(file_id), current_id));
%     end
%     current_file_ids(j) = file_id;
%   end
%   
%   file_ids{i} = current_file_ids;
% end
% 
% result.test.file_ids = file_ids;
