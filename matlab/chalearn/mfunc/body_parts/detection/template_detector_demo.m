function [result, boxes] =  template_detector_demo(image, template, ...
                                      scales, rotations, result_number)

% function [result, boxes] =  template_detector_demo(image, template, ...
%                                       scales, rotations, result_number)
%
% returns an image that is a copy of the input image, with 
% the bounding boxes drawn for each of the best matches for 
% the template in the image, after searching all specified 
% scales and rotations.

boxes = find_template(image, template, scales, rotations, result_number);
result = image;

for number = 1:result_number
    result = draw_rectangle1(result, boxes(number, 1), boxes(number, 2), ...
                             boxes(number, 3), boxes(number, 4));
end
