function result = depth_segmentation(frame, threshold)

[rows, cols] = size(frame);
result = zeros(rows, cols);

center_rows = 2:(rows-1);
center_cols = 2:(cols-1);

center = frame(center_rows, center_cols);
left = frame(center_rows, center_cols-1);
right = frame(center_rows, center_cols+1);
top = frame(center_rows-1, center_cols);
bottom = frame(center_rows+1, center_cols);

a1 = (abs(center-left) <= threshold);
a2 = (abs(center-right) <= threshold);
a3 = (abs(center-top) <= threshold);
a4 = (abs(center-bottom) <= threshold);

selection = a1 & a2 & a3 & a4;
result(center_rows, center_cols) = selection;
result(frame == 0) = 0;

