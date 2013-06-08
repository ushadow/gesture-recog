function result = normalize_motion_sequence(motion, frame_size, vertical_size, horizontal_size, threshold)

% function result = normalize_motion_sequence(motion, frame_size, vertical_size, 
%                                             horizontal_size, threshold)
%
% motion is the result of motion_sequence.
% frame_size, vertical_size, horizontal_size specify the size of the
% result. 
% threshold specifies the value used for identifying and cropping areas 
% of motion in the input "motion" argument
%
% The result is a normalized version of  motion, that identifies
% and crops areas of motion, and then normalizes those areas to a
% canonical size

input_frames = numel(motion);
result = cell(frame_size, 1);
input_vertical = size(motion{1}, 1);
input_horizontal = size(motion{1}, 2);
band_size = size(motion{1}, 3);

sample_space = (input_frames - 1) / (frame_size - 1);
sample_frames = round(1:sample_space:input_frames);

for counter =  1:frame_size
  frame_number = sample_frames(counter);
  current_motion = motion{frame_number};
  thresholded = (current_motion > threshold);
  t = sum(thresholded(:));
  if (t == 0)
    new_motion = zeros(vertical_size, horizontal_size);
  else
    [top, bottom, left, right] = find_bounding_box(thresholded);
    cropped =  current_motion (top: bottom, left: right);
    new_motion = normalize_size(cropped,  vertical_size, horizontal_size);
  end
  result{counter} = new_motion;
end


