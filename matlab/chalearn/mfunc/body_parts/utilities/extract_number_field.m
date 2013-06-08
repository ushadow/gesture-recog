function result = extract_number_field (array, field_name)

% function result = extract_number_field (array, field_name)

% if array is a cell array, this function produces a matrix that contains,
% for each element of the array, the field value for the specified field)
% This would not work if the value of the field is not a number

number = numel(array);
result = zeros(number, 1);

for counter = 1:number
    result (counter) = getfield (array{counter}, field_name);
end

