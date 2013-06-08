function [value, row, col] = image_maximum(image)

% function [value, row, col] = image_maximum(image)

value = max(image(:));
[rows cols] = find(image == value);
row = rows(1);
col = cols(1);


