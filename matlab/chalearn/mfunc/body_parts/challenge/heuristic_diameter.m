function [row1, col1, row2, col2, distance] = heuristic_diameter(contour_pixels)

number = size(contour_pixels, 1);

row2 = contour_pixels(1,1);
col2 = contour_pixels(1,2);

number_of_passes = 3;

for pass = 1:number_of_passes
  max_distance = -1;
  row1 = row2;
  col1 = col2;
  
  for counter = 1:number
    row = contour_pixels(counter, 1);
    col = contour_pixels(counter, 2);

    drow = row - row1;
    dcol = col - col1;
    dist = drow * drow + dcol * dcol;
    if (dist > max_distance)
      max_distance = dist;
      row2 = row;
      col2 = col;
    end
  end
end

distance = sqrt(max_distance);
