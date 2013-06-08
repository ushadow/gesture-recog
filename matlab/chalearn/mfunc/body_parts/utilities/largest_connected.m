function result = largest_connected(binary)

%  result = largest_connected(binary)
%
% returns a boolean image where non-zero pixels represent
% the largest connected component of the input image

result = get_component(binary, 1);
