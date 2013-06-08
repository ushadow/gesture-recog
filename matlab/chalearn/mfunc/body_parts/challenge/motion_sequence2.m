function result = motion_sequence2(arg1, arg2, arg3)

% function result = motion_sequence(dataset, subset, number)
% function result = motion_sequence(frames)
%
% dataset is a result of calling function make_dataset
% subset is 'tr' or 'te' for training or test set
% number is the index of the video we want to read
%
% alternatively, frames can be the result of get_frames.

if (nargin == 3)
  frames = get_frames (arg1, arg2, arg3);
elseif (nargin == 1)
  frames = arg1;
end

number = length(frames);
result = cell(number-2, 1);
vertical_size = size(frames(1).cdata, 1);
horizontal_size = size(frames(1).cdata, 2);
band_size = size(frames(1).cdata, 3);

for  (counter =  2:(number-1))
  current_result = zeros (vertical_size, horizontal_size);
  previous_frame = double(frames (counter -1).cdata);
  current_frame = double(frames (counter).cdata);
  next_frame = double(frames (counter +1).cdata);
  for band = 1:band_size
    first_difference = abs(previous_frame(:,:,band) - current_frame(:,:,band));
    second_difference = abs(next_frame(:,:,band) - current_frame(:,:,band));
    current_result = current_result + min(first_difference, second_difference);
  end
  result{counter-1} = current_result / band_size;
end

