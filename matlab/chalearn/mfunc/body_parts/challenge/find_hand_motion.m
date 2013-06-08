function [result_image, result_centers, result_side] = ...
  find_hand_motion(previous, current, next, face_center, face_size, ...
                   previous_result, parameters)
                 
% function [result_image, result_centers, result_side] = ...
%  find_hand_motion(previous, current, next, face_center, face_size, ...
%                   previous_result, parameters)
%
% produces hand candidates based primarily on frame differencing

[rows, cols] = size(current);
diff = frame_difference(previous, current, next);
diff(current == 0) = 0;
diff(previous == 0) = 0;
diff(next == 0) = 0;
%figure(2); imshow(diff > 40, []);                 

depth = current(face_center(1), face_center(2));
selection1 = (current < depth + 100) & (current ~= 0);
selection2 = (diff > 40);

body_motion_binary = selection1 & selection2;

face_height = face_size(1);
parameters = struct('required_area', 'square_side');
parameters.required_area = round((face_height / 10) ^ 2);
parameters.square_side = (round(face_height/6)) * 2 + 1;

% for debugging
component = largest_connected(body_motion_binary);
figure(2); imshow(component, []);

[result_image, result_centers] = candidates_from_connected(current, diff, body_motion_binary, parameters);
result_side = parameters.square_side;


% for counter = 1:selected_number
%   label = selected_labels(counter);
%   label_region = (labels == label);
%   label_motion = double(label_region) .* diff;
%   averaged1 = imfilter(label_motion, ones(hand_side, 1) / hand_side, 'same');
%   averaged = imfilter(averaged1, ones(1, 1) / hand_side, 'same');
%   averaged = averaged .* label_region;
%   
%   while(1)
%     area = sum(averaged(:) > 0);
%     if (area < required_area)
%       break;
%     end
%     result_index = result_index + 1;
%     max_value = max(averaged(:));
%     [row_indices, col_indices] = find(averaged == max_value);
%     
%     row = row_indices(1);
%     col = col_indices(1);
%     result_centers(result_index, 1) = row;
%     result_centers(result_index, 2) = col;
%     top = max(1, row - half_side);
%     bottom = min(rows, row + half_side);
%     left = max(1, col - half_side);
%     right = min(cols, col + half_side);
%     result_image = draw_rectangle1(result_image, top, bottom, left, right);
%     averaged(top:bottom, left:right) = 0;
%   end
% end
% 
% result_centers = result_centers(1:result_index, :);
% result_side = hand_side;
% 
