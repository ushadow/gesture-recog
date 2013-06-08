function result = matching_filenames(pattern)

% function result = directory_files(pattern)
%
% returns the filenames that match a specific pattern,
% in ascending alphabetical order

files = dir(pattern);
file_number = numel(files);
names = cell(file_number, 1);
for i = 1:file_number
    names{i} = files(i).name;
end

result = sort(names);
