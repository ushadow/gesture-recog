function [max_responses, max_scales, max_rotations] = ...
    template_search(image, template, scales, rotations, result_number)

% function [result, max_scales, max_rotations] = ...
%    template_search(image, template, scales, rotations, result_number)
%
% for each pixel, search over the specified scales and rotations,
% and record:
% - in result, the max normalized correlation score for that pixel
%   over all scales
% - in max_scales, the scale that gave the max score 
% - in max_rotations, the rotation that gave the max score 
%
% clockwise rotations are positive, counterclockwise rotations are 
% negative.
% rotations are specified in degrees

max_responses = ones(size(image)) * -10;
max_scales = zeros(size(image));
max_rotations = zeros(size(image));

for rotation = rotations
    rotated = imrotate(image, -rotation, 'bilinear', 'crop');
    [responses, temp_max_scales] = multiscale_correlation(rotated, template, scales);
    responses = imrotate(responses, rotation, 'nearest', 'crop');
    temp_max_scales = imrotate(temp_max_scales, rotation, 'nearest', 'crop');
    higher_maxes = (responses > max_responses);
    max_responses(higher_maxes) = responses(higher_maxes);
    max_scales(higher_maxes) = temp_max_scales(higher_maxes);
    max_rotations(higher_maxes) = rotation;
end