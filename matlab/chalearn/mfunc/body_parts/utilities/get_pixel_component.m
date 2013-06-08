function result = get_pixel_component(binary, i, j)

%  function result = get_pixel_component(binary, i, j)
%
% returns a boolean image where non-zero pixels represent
% the connected component of the input image that pixel i, j belongs to

% connected component analysis
[labels, number] = bwlabel(binary, 4);

id = labels(i,j);
result = (labels == id);
