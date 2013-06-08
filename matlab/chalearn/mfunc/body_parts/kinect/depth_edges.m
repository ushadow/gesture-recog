function result = depth_edges(frame, low_threshold, high_threshold)

% function result = depth_edges(frame, low_threshold, high_threshold)

[rows, cols] = size(frame);
center_rows = 2:(rows-1);
center_cols = 2:(cols-1);

max_value = max(frame(:));
frame(frame == 0) = max_value;

center = frame(center_rows, center_cols);
left = frame(center_rows, center_cols-1);
right = frame(center_rows, center_cols+1);
top = frame(center_rows-1, center_cols);
bottom = frame(center_rows+1, center_cols);

differences = left - center;
differences = max(differences, right-center);
differences = max(differences, top-center);
differences = max(differences, bottom-center);

% pad differences with zeros on top, bottom, left, right, to make
% differences have the same size as frame
temp = differences;
differences = zeros(rows, cols);
differences(center_rows, center_cols) = temp;

result = hysthresh(differences, low_threshold, high_threshold);

