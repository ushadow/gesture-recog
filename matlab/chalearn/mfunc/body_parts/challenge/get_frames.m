function result = get_frames(dataset, subset, number)

% function result = get_frames(dataset, subset, number)
%
% dataset is a result of calling function make_dataset
% subset is 'tr' or 'te' for training or test set
% number is the index of the video we want to read

if (strcmp(subset, 'tr'))
    filename = dataset.training.filenames{number};
elseif (strcmp(subset, 'te'))
    filename = dataset.test.filenames{number};
else
  error(sprintf('get_frames second argument = %s, should be tr or te', subset));
end

mov = aviread(filename);

result = extract_field(mov, 'cdata');

