function result =  frame_difference (previous, current, next)

first_difference = abs(previous - current);
second_difference = abs(current - next);

if (ndims(current) == 3)
  first_difference = sum(first_difference, 3);
  second_difference = sum(second_difference, 3);
end

result = min (first_difference, second_difference);
