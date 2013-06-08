function result = get_class_index(dataset, class_id)

indices = find(dataset.training.class_ids == class_id);
if (numel(indices) ~= 1)
  error(sprintf('error in get_class_index: %d class indices found', numel(indices)));
end

result = indices(1);
