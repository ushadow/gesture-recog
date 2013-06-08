function result = find_template(image, template, scales, rotations, result_number)

% function result = find_template(image, template, scales, rotations,
%                                 result_number)
% returns the bounding boxes of the best matches for the template in
% the image, after searching all specified scales and rotations.
% result_number specifies the number of results (bounding boxes).

[max_responses, max_scales, max_rotations] = ...
    template_search(image, template, scales, rotations, result_number);

result = detection_boxes(image, template, max_responses, ...
                         max_scales, result_number);
