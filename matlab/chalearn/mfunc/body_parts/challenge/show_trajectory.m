function result = show_trajectory(trajectory, rows, cols)

step_image = zeros(rows, cols);
number = size(trajectory, 1);

for i = 1:(number-1)
  point1 = trajectory(i,:);
  point2 = trajectory(i+1,:);
  step_image = draw_line_value(step_image, point1, point2, number-i);
end

result = color_code(step_image);

  