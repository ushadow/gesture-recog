function result = extract_field (array, field_name)

% function result = extract_field (array, field_name)

% if array is a cell array, this function produces a cell array that contains,
% for each element of the array, the field value for the specified field

[rows, cols] = size(array);
result = cell(rows, cols);
number = numel(array);

if (iscell(array))
  for counter = 1:number
    result{counter} = getfield (array{counter}, field_name);
  end
elseif (isstruct(array))  
  for counter = 1:number
    result{counter} = getfield (array(counter), field_name);
  end
end

