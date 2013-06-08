function result = models_filename(dataset_name)

dirname = dataset_directory(dataset_name);
result = sprintf('%s/models.mat', dirname);

