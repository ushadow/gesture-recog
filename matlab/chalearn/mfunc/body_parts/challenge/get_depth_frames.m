function result = get_depth_frames(dataset, subset)

% function result = get_depth_frames(dataset, subset, number)

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

[parent, name, extension] = fileparts(filename);
if strcmp(extension, '.mat')
  load(filename);
  [rows, cols] = size(K{1});
  disp(sprintf('original size = %d x %d', [rows, cols]));
  for i = 1:numel(K)
    result{i} = imresize(K{i}, [240, 320], 'nearest');
  end
elseif strcmp(extension, '.avi')
  obj = mmreader(filename);
  frames = read(obj);
  number_of_frames = size(frames, 4);
  result = cell(number_of_frames, 1);
  for i = 1:number_of_frames
    result{i} = frames(:,:,1,i);
    result{i}(result{i} <= 5) = 0;
  end
else
  result = [];
end

  

