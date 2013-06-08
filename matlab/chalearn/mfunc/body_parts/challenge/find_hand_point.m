function [result, depth] = find_hand_point(depth_frame)

% function result = find_hand_point(depth_frame)
%
% returns the coordinate of a pixel that we expect to belong to the hand.
% very simple implementation, we assume that the hand is the closest object
% to the sensor.

max_value = max(depth_frame(:));
current2 = depth_frame;
current2(depth_frame == 0) = max_value;
blurred = imfilter(current2, ones(5, 5)/25, 'symmetric', 'same');
minimum = min(blurred(:));
[is, js] = find(blurred == minimum);
result = [is(1), js(1)];
depth = minimum;
