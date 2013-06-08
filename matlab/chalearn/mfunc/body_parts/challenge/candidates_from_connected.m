function [result_image, result_centers, result_scores] = ...
  candidates_from_connected(depth_image, pixel_scores, binary, parameters)
                 
% function [result_image, result_centers, result_scores] = ...
%   candidates_from_connected(depth_image, pixel_scores, binary, parameters)

[rows, cols] = size(depth_image);
[labels_image, sorted_labels, sorted_areas] = connected_components(binary);

square_side = parameters.square_side;
if (mod(square_side, 2) == 0)
  square_side = square_side + 1;
end
half_side = floor(square_side / 2);
required_area = parameters.required_area;

indices = (sorted_areas >= required_area);
selected_labels = sorted_labels(indices);
selected_areas = sorted_areas(indices);
selected_number = numel(selected_labels);

max_possible_results = ceil(5 * rows * cols / (square_side * square_side));

result_centers = zeros(max_possible_results, 3);
result_scores = zeros(max_possible_results, 1);
result_index = 0;
result_image = normalize_range(depth_image);

blur_template = [1:1:half_side, (half_side+1):-1:1];
blur_template = blur_template / sum(blur_template);

for counter = 1:selected_number
  if (result_index >= parameters.number_of_results)
    break;
  end
  label = selected_labels(counter);
  label_region = (labels_image == label);
  label_motion = double(label_region) .* pixel_scores;
  averaged1 = imfilter(label_motion, blur_template, 'same');
  averaged = imfilter(averaged1, blur_template', 'same');
  averaged = averaged .* label_region;
  area = sum(averaged(:) > 0);
  
  area_threshold = square_side * square_side / 4;
  if (area < area_threshold)
    area_threshold = area;
  end
  
  
  while(1)
    if (result_index >= parameters.number_of_results)
      break;
    end
    area = sum(averaged(:) > 0);
    if (area < area_threshold)
      break;
    end
    result_index = result_index + 1;
    max_value = max(averaged(:));
    [row_indices, col_indices] = find(averaged == max_value);
    
    row = row_indices(1);
    col = col_indices(1);
    result_centers(result_index, 1) = row;
    result_centers(result_index, 2) = col;
    result_centers(result_index, 3) = depth_image(row, col);
    result_scores(result_index) = max_value;
    top = max(1, row - half_side);
    bottom = min(rows, row + half_side);
    left = max(1, col - half_side);
    right = min(cols, col + half_side);
    result_image = draw_rectangle1(result_image, top, bottom, left, right);
    averaged(top:bottom, left:right) = 0;
  end
end

result_centers = result_centers(1:result_index, :);
result_scores = result_scores(1:result_index, :);

