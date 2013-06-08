function result = draw_line2(image, distance, theta)

% function result = draw_line2(image, distance, theta)
%
% draws the line whose distance from origin is "distance" and
% for which the vertical connecting it to the origin makes angle
% theta with the x axis (matching the output of hough transform).
% theta is given in degrees

theta_rad = theta / 180 * pi;

x1 = distance * cos(theta_rad);
y1 = distance * sin(theta_rad);

theta2 = theta_rad + pi/2;
stepx = cos(theta2);
stepy = sin(theta2);

rows = size(image, 1);
cols = size(image, 2);

if (stepx == 0)
    result = draw_line([1, x1], [rows, x1]);
    return;
end

if (stepy == 0)
    result = draw_line(image, [y1, 1], [y1, cols]);
    return;
end

x2 = 1;
steps2 = (x2 - x1) / stepx;
y2 = y1 + steps2 * stepy;

y3 = 1;    
steps3 = (y3 - y1) / stepy;
x3 = x1 + steps3 * stepx;

x4 = cols;
steps4 = (x4 - x1) / stepx;
y4 = y1 + steps4 * stepy;

y5 = rows;    
steps5 = (y5 - y1) / stepy;
x5 = x1 + steps5 * stepx;

xs = zeros(2, 1);
ys = zeros(2, 1);
index = 1;

if (y2 >= 1) & (y2 <= rows)
    xs(index) = x2;
    ys(index) = y2;
    index = index + 1;
end

if (x3 >= 1) & (x3 <= cols) & any([y3 x3] ~= [ys(1) xs(1)])
    xs(index) = x3;
    ys(index) = y3;
    index = index + 1;
end

if (y4 >= 1) & (y4 <= rows) & any([y4 x4] ~= [ys(1) xs(1)]) & (index <= 2)
    xs(index) = x4;
    ys(index) = y4;
    index = index + 1;
end

if (x5 >= 1) & (x5 <= cols) & any([y5 x5] ~= [ys(1) xs(1)]) & (index <= 2)
    xs(index) = x5;
    ys(index) = y5;
    index = index + 1;
end

result = draw_line(image, [ys(1), xs(1)], [ys(2), xs(2)]);

