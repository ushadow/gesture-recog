function data = subsample(data, factor)

dataField = {'Y', 'X', 'frame'};
for i = 1 : length(dataField)
  field = dataField{i};
  if isfield(data, field)
    data.(dataField{i}) = cellfun(@(x) x(:, 1 : factor : end), ...
        data.(dataField{i}), 'UniformOutput', false);
  end
end
end