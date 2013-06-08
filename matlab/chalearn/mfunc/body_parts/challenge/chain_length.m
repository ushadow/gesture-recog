function  [distance, end_i, end_j] = ...
  chain_length(labels_image, start_i, start_j, start_side, max_pixels, direction)

% function  [distance, end_i, end_j] = ...
%  chain_length(labels_image, start_i, start_j, start_side, max_pixels, direction)

% to avoid needing to check for getting out of boundary, we enforce that
% boundary pixels are 0.

[rows, cols] = size(labels_image);
label = labels_image(start_i, start_j);
if (label == 0)
  error('error: label of start pixel cannot be 0');
end

labels_image([1, rows], :) = 0;
labels_image(:, [1, cols]) = 0;

[rows, cols] = size(labels_image);
order = zeros(4, 4);

% order{1}[1,:] format: diag_i, diag_j, neighbor_i, neighbor_j

if (strcmp(direction, 'clockwise') == 1)
  order = [
    -1, 1, 0, 1;
    1, 1, 1, 0;
    1, -1, 0, -1;
    -1, -1, -1, 0;
    ];
  order_factor = 1;
elseif (strcmp(direction, 'counterclockwise') == 1)
  order = [
    -1, -1, 0, -1;
    -1, 1, -1, 0;
    1, 1, 0, 1;
    1, -1, 1, 0;
  ];
  order_factor = -1;
else
  error('direction should be clockwise or counterclockwise');
end

current_i = start_i;
current_j = start_j;
current_side = start_side;

best_i = current_i;
best_j = current_j;
best_distance = 0;

for counter = 1:max_pixels
  order_info = order(current_side, :);
  diag_i = current_i + order_info(1);
  diag_j = current_j + order_info(2);
  
  if (labels_image(diag_i, diag_j) == label)
    current_i = diag_i;
    current_j = diag_j;
    current_side = mod(current_side + 4 + 3 * order_factor, 4);
    if (current_side == 0)
      current_side = 4;
    end
  else
    neighbor_i = current_i + order_info(3);
    neighbor_j = current_j + order_info(4);
    if (labels_image(neighbor_i, neighbor_j) == label)
      current_i = neighbor_i;
      current_j = neighbor_j;
  %    current_side = current_side;
    else
  %    current_i = neighbor_i;
  %    current_j = neighbor_j;
      current_side = mod(current_side + 4 + 1 * order_factor, 4);
      if (current_side == 0)
        current_side = 4;
      end
    end
  end
  diff_i = current_i - start_i;
  diff_j = current_j - start_j;
  distance = sqrt(diff_i * diff_i + diff_j * diff_j);
  if (distance > best_distance)
    best_distance = distance;
    best_i = current_i;
    best_j = current_j;
  end
end

end_i = best_i;
end_j = best_j;
distance = best_distance;
 