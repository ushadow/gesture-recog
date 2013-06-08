function result = accuracy_filename(dataset_name)

dirname = dataset_directory(dataset_name);
result = sprintf('%s/accuracy.mat', dirname);

