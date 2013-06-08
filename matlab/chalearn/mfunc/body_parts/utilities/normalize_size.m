function result = normalize_size(input, new_vertical, new_horizontal)

% function result = normalize_size(input, new_vertical, new_horizontal)
%
% resizes the input image, so as to produce an output image  with the
% specified new_vertical and new_horizontal size. imresize is used  to produce the
% new image, and the desired aspect ration is achieved by padding with
% zeros ( either at the top and bottom, or  at the left and right  margins)

vertical_size = size (input, 1);
horizontal_size = size (input, 2);

vertical_scale =  new_vertical/vertical_size;
horizontal_scale = new_horizontal/horizontal_size;

scale =  min(vertical_scale, horizontal_scale);
resized_vertical =  round(scale * vertical_size);
resized_horizontal =  round(scale * horizontal_size);
resized = imresize(input, [resized_vertical, resized_horizontal], 'bilinear');

vertical_difference = new_vertical - resized_vertical;
horizontal_difference = new_horizontal - resized_horizontal;
vertical_start  =  round (vertical_difference / 2) + 1;
vertical_finish  = vertical_start + resized_vertical -1;
horizontal_start = round (horizontal_difference / 2) +1;
horizontal_finish =  horizontal_start + resized_horizontal -1;

% for debugging
box = [vertical_start, vertical_finish, horizontal_start, horizontal_finish];
if ((min(box) <= 0) | (vertical_finish > new_vertical) | (horizontal_finish > new_horizontal))
  error('an error has occurred in normalize_size');
end

result = zeros (new_vertical,  new_horizontal);
result (vertical_start: vertical_finish, horizontal_start: horizontal_finish) = resized;

