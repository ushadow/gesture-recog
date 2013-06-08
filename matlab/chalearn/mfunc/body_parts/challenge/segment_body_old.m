function result = segment_body(current_depth, face_info, parameters)

% result = segment_body(current_depth, face_info, parameters)

if (nargin < 3)
  extra_depth = 100;  
%   depth_edge_low = 10;  
  depth_edge_high = 200;  
else
  extra_depth = parameters.extra_depth;
%   depth_edge_low = parameters.depth_edge_low;
  depth_edge_high = parameters.depth_edge_high;
end

[rows, cols] = size(current_depth);
possible_body = ((current_depth < (face_info.depth + extra_depth)) & (current_depth ~= 0));
possible_body2 = largest_connected(possible_body);
possible_body3 = imerode(possible_body2, ones(3,3));
possible_body3([1,2,rows-1,rows],:) = 0;
possible_body3(:, [1, 2, cols-1, cols]) = 0;
[all_rows, all_cols] = find(possible_body3 ~= 0);
if (sum(possible_body3(:)) == 0)
  result = possible_body3;
  return;
end

de = depth_edges(current_depth, parameters.depth_edge_low_body_segmentation, depth_edge_high);
segmented = ~de;
segmented(possible_body3) = 1;
segmented([1,2,rows-1,rows],:) = 0;
segmented(:, [1, 2, cols-1, cols]) = 0;

labels = bwlabel(segmented, 4);
body_label = labels(all_rows(1), all_cols(1));

result = (labels == body_label);

if  (  sum(result(:)) /  (size(current_depth,1) * size(current_depth,2)) > 0.7 )
   result = possible_body; 
else
    result = result | possible_body;
end


