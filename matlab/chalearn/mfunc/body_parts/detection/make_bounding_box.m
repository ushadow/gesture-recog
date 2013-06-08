function result = make_bounding_box(vertical_center, horizontal_center, box_size)

% function result = make_bounding_box(vertical_center, horizontal_center, box_size)

box_vertical = box_size(1);
box_horizontal = box_size(2);

half_vertical = floor(box_vertical / 2);
half_horizontal = floor(box_horizontal / 2);
left = horizontal_center - half_horizontal + 1;
right = left + box_horizontal -1;
top = vertical_center - half_vertical +1;
bottom = top + box_vertical-1;

result = [top bottom left right];
