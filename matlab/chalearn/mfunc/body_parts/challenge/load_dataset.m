function result = load_dataset(dataset_name)

% function result = load_dataset(dataset_name)

result = make_dataset(dataset_name);
models_name = models_filename(dataset_name);

if (exist(models_name) == 2)
  load(models_name);
  result.models = models;
  result.parameters = parameters;
end


