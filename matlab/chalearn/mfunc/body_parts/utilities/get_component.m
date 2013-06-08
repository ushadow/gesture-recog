function result = get_component(binary, k)

%  result = get_component(binary)
%
% returns a boolean image where non-zero pixels represent
% the k-th largest connected component of the input image

[labels, sorted_labels, areas] = connected_components(binary);
if (numel(sorted_labels) < k)
  result = [];
else
  result = (labels == sorted_labels(k));
end


