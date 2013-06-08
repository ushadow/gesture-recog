function result = draw_line_value(image, point1, point2, value)

% function result = draw_line(image, [y1, x1], [y2, x2], value)

result = image;

y1 = point1(1);
x1 = point1(2);
y2 = point2(1);
x2 = point2(2);

stepsy = abs(y1 - y2);
stepsx = abs(x1 - x2);
steps = max(stepsy, stepsx) + 1;
if (y1 <= y2)
    directiony = 1;
else
    directiony = -1;
end

if (x1 <= x2)
    directionx = 1;
else
    directionx = -1;
end

stepy = stepsy / steps * directiony;
stepx = stepsx / steps * directionx;

for i = 1:steps
    y = round(y1 + i * stepy);
    x = round(x1 + i * stepx);
    result(y, x) = value;
end
