function result = depth_data(frame)

% extracts the depth data from video where rgb is on the top half, and
% depth is at the bottom half

rows = size(frame, 1);
cols = size(frame, 2);

result = double(frame((rows/2+1):rows, :, 1));
