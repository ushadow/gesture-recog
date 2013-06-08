function result = extract_trajectory1(frames)

% function result = extract_trajectory1(frames)
% 
% returns a time series of hand positions found using find_hand_point

number = numel(frames);
result = zeros(number, 2);

for i = 1:number
  frame = frames{i};
  result(i, :) = find_hand_point(frame);
end

