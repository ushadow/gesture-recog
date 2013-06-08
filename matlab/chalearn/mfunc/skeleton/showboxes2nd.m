function [bsx]=showboxes2nd(boxes)
% [bsx]=showboxes2nd(boxes) 
% Extracts coordinates information from the boxes generated with Deva
% Ramanan's code
numparts = floor(size(boxes, 2)/4);
for i = 1:numparts
x1 = boxes(:,1+(i-1)*4);
y1 = boxes(:,2+(i-1)*4);
x2 = boxes(:,3+(i-1)*4);
y2 = boxes(:,4+(i-1)*4);
bsx(i,:)=[x1, y1, x2, y2, x1+((x2-x1)./2),y1+((y2-y1)./2),(x2-x1).*(y2-y1)];
end


  