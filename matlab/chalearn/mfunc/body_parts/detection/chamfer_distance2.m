function result = chamfer_distance2(distance_transform, template)

% function result = chamfer_distance2(distance_transform, template)
%
% scores of directed chamfer distance from template to image

result = imfilter(distance_transform, template, 'same', inf);
