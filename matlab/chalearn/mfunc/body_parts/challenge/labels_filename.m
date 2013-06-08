function result = labels_filename(dataset_name)

dirname = dataset_directory(dataset_name);

%pattern = sprintf('%s/*.labels', dirname);
pattern = sprintf('%s/*.label', dirname);
matching_names = dir(pattern);

if (numel(matching_names) ~= 1)
  error('%d files found matching %s', numel(matching_names), pattern);
end

result = sprintf('%s/%s', dirname, matching_names(1).name);


