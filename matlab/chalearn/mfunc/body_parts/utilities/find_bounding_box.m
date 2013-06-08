function [top, bottom, left, right] = find_bounding_box(input)

% function result = find_bounding_box(input)

vertical_projection = sum(input, 2);
horizontal_projection = sum(input, 1);

range = find(vertical_projection > 0);
top = range(1);
bottom = range(numel(range));

range = find(horizontal_projection > 0);
left = range(1);
right  = range(numel(range));

