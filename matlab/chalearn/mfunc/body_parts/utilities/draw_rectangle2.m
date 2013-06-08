function result = draw_rectangle2(frame, center_row, center_col, height, width);

% function result = draw_rectangle2(frame, center_row, center_col, height, width);
%
% frame is a grayscale or color image. result is a copy of frame 
% with a white rectangle superimposed.

half_rows = floor(height / 2);
half_cols = floor(width / 2);

current_top = center_row - half_rows;
current_bottom = center_row + half_rows;
current_left = center_col - half_cols;
current_right = center_col + half_cols;

result = draw_rectangle1(frame, current_top, current_bottom, current_left, current_right);

