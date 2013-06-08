function result = find_arm_line(current, face_center, face_size, cand_i, cand_j)

[rows, cols] = size(current);
face_depth = current(face_center(1), face_center(2));
body_position = (current < face_depth + 100) & (current ~= 0);

edges = depth_edges(current, 30, 200);
edges = edges .* body_position;
%figure(5); imshow(edges, []);

[labels_image, sorted_labels, sorted_areas] = connected_components(edges, 8);
search_area = round(face_size(2) / 4);

top = max(1, cand_i - search_area);
bottom = min(rows, cand_i + search_area);
left = max(1, cand_j - search_area);
right = min(cols, cand_j + search_area);

cand_labels = zeros(4, 4);

% convention for sides of pixels:
% 1 is top
% 2 is right
% 3 is bottom
% 4 is left

for i = cand_i:-1:top
  cand_index = 1;
  j = cand_j;
  label = labels_image(i, j);
  if (label ~= 0)
    cand_labels(cand_index, 1) = label;
    cand_labels(cand_index, 2) = i;
    cand_labels(cand_index, 3) = j;
    cand_labels(cand_index, 4) = 3; % we are hitting the pixel from bottom
    break;
  end
end

for i = cand_i:bottom
  cand_index = 2;
  j = cand_j;
  label = labels_image(i, cand_j);
  if (label ~= 0)
    cand_labels(cand_index, 1) = label;
    cand_labels(cand_index, 2) = i;
    cand_labels(cand_index, 3) = j;
    cand_labels(cand_index, 4) = 1; % we are hitting the pixel from top
    break;
  end
end

for j = cand_j:-1:left
  cand_index = 3;
  i = cand_i;
  label = labels_image(i, j);
  if (label ~= 0)
    cand_labels(cand_index, 1) = label;
    cand_labels(cand_index, 2) = i;
    cand_labels(cand_index, 3) = j;
    cand_labels(cand_index, 4) = 2; % we are hitting the pixel from right
    break;
  end
end

for j = cand_j:right
  cand_index = 4;
  i = cand_i;
  label = labels_image(i, j);
  if (label ~= 0)
    cand_labels(cand_index, 1) = label;
    cand_labels(cand_index, 2) = i;
    cand_labels(cand_index, 3) = j;
    cand_labels(cand_index, 4) = 4; % we are hitting the pixel from left
    break;
  end
end

disp(cand_labels);
max_distance_info = zeros(1,5);

for counter = 1:4
  start_i = cand_labels(counter, 2);
  if (start_i == 0)
    continue;
  end
  start_j = cand_labels(counter, 3);
  start_side = cand_labels(counter, 4);
  max_pixels = round(face_size(2) * 1.5);
  [distance, end_i, end_j] = chain_length(labels_image, start_i, start_j, start_side, max_pixels, 'clockwise');
  if (distance > max_distance_info(1))
    max_distance_info = [distance, start_i, start_j, end_i, end_j];
  end
  
  [distance, end_i, end_j] = chain_length(labels_image, start_i, start_j, start_side, max_pixels, 'counterclockwise');
  if (distance > max_distance_info(1))
    max_distance_info = [distance, start_i, start_j, end_i, end_j];
  end
end
  
result = max_distance_info;
%current = normalize_range(current);
%result_image = draw_line(current, max_distance_info(2:3), max_distance_info(4:5));
%figure(5); imshow(result_image, []);

