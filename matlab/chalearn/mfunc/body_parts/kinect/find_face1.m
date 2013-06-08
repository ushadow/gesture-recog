function result = find_face1(frame, scales)

% function result = find_face1(frame)
%
% it takes as argument a depth frame. It uses chamfer matching with a face
% template.

% it searches at quarter resolution.

[rows, cols] = size(frame);
