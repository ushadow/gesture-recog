function result = chamfer_distance1(edge_image, template)

% function result = chamfer_distance1(edge_image, template)
%
% scores of directed chamfer distance from template to image

distance_transform = bwdist(edge_image);
result = chamfer_distance2(distance_transform, template);
