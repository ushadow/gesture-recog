function result = skeletal_image(dt)

[rows, cols] = size(dt);
center_rows = 2:(rows-1);
center_cols = 2:(cols-1);

center = dt(center_rows, center_cols);
left = dt(center_rows, center_cols-1);
right = dt(center_rows, center_cols+1);
top = dt(center_rows-1, center_cols);
bottom = dt(center_rows+1, center_cols);

left_differences = left - center;
left_differences = max(left_differences, right-center);
top_differences = top-center;
top_differences = max(top_differences, bottom-center);

% pad differences with zeros on top, bottom, left, right, to make
% differences have the same size as frame
temp = (left_differences < 0) | (top_differences < 0);
result = zeros(rows, cols);
result(center_rows, center_cols) = temp;
result = result .* dt;