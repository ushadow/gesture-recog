function result = vocabulary_filename(dataset_name)

dirname = dataset_directory(dataset_name);

%pattern = sprintf('%s/*.vocabulary', dirname);
pattern = sprintf('%s/*_train.labels', dirname);
matching_names = dir(pattern);

if (numel(matching_names) ~= 1)
  error('%d vocabulary files found matching %s', numel(matching_names), pattern);
end

result = sprintf('%s/%s', dirname, matching_names(1).name);


