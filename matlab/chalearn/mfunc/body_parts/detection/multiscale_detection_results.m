function [result, centers, result_scales] = ...
    multiscale_detection_results(frame, scores, scales, object_size, ...
                                 suppression_factor, number)

% function [result, centers] = ...
%     multiscale_detection_results(frame, scores, hand_size, ...
%                           suppression_factor, number)
%
% The frame is an image, on top of which squares will be drawn to indicate
%     the detected locations.
% The scores are assumed to be detection scores (high scores are good).
% The scales indicate, for each location, the optimal detection scale for
%     that location.
% The object size (a matrix [height, width]) is used (together with scales)
%     to estimate the size of the rectangle that will be drawn 
%     centered on each result.
% The suppression factor indicates the number of neighboring pixels to
%     suppress around each detection. A factor of 1 corresponds to
%     suppressing all locations within the bounding box of each detected
%     location. A factor of 0.5 means that the sides of the box containing 
%     the suppressed locations will be half the length of the sides 
%     of the bounding box of the detection.

object_half_rows = floor(object_size(1) / 2);
object_half_cols = floor(object_size(2) / 2);

result = frame;
centers = zeros(number, 2);
result_scales = zeros(number, 1);
rows = size(frame, 1);
cols = size(frame, 2);

colors = zeros(number, 3) ;
colors(1,:) = [255 255 255];
colors(2,:) = [0 255 0];
colors(3,:) = [0 0 255];
colors(4,:) = [255 0 255];
colors(5,:) = [255 255 0];
for i = 1:number
    max_score = max(max(scores));
    [max_rows, max_cols] = find(scores == max_score);
    max_location = [max_rows(1), max_cols(1)];
    centers(i, :) = max_location;
    result_scales(i) = scales(max_location(1), max_location(2));
    
    scale = scales(max_location(1), max_location(2));
    half_rows = round(object_half_rows * scale);
    half_cols = round(object_half_cols * scale);
    
    current_top = max_location(1) - half_rows;
    current_bottom = max_location(1) + half_rows;
    current_left = max_location(2) - half_cols;
    current_right = max_location(2) + half_cols;

    
    result = draw_rectangle3(result, current_top, current_bottom, ...
                             current_left, current_right, colors(i,:));
    
    top = max(1, round(max_location(1) - half_rows * suppression_factor));
    bottom = min(rows, round(max_location(1) + half_rows * suppression_factor));
    left = max(1, round(max_location(2) - half_cols * suppression_factor));
    right = min(cols, round(max_location(2) + half_cols * suppression_factor));

    scores(top:bottom, left:right) = -inf;
end


