function result = ...
    detection_boxes(image, template, max_responses, ...
                    max_scales, result_number);

% function result = ...
%     detection_boxes(max_responses, max_scales, max_rotations, template);
%
% returns a matrix, where every row specifies a bounding box

[image_rows image_columns] = size(max_responses);
result = zeros(result_number, 6);
number = 1;
for number = 1:result_number
    [value, vertical, horizontal] = image_maximum(max_responses);
    result_scale = max_scales(vertical, horizontal);
    box = make_bounding_box(vertical, horizontal, round(result_scale * size(template)));
    result(number, 1:4) = box;
    
    top = max(box(1),1);
    bottom = min(box(2), image_rows);
    left = max(box(3), 1);
    right = min(box(4), image_columns);
    window = image(top:bottom, left:right);
    result(number, 5) = value;
    result(number, 6) = std(window(:));

    max_responses(top:bottom, left:right) = -10;
end
