function [result_center result_score] = get_hand_center(depth_image, parameters, hand_row, hand_col, selected, scores)

    [rows, cols] = size(depth_image);
    hand_point_image = zeros(rows, cols);
    hand_point_image(hand_row, hand_col) = 1;
    hand_point_dt = bwdist(hand_point_image);

    hand_region = (hand_point_dt <= (parameters.square_side * 1.5));
    hand_region(selected == 0) = 0;

    [hand_rows, hand_cols] = find(hand_region);

    result_center = [round(mean(hand_rows)), round(mean(hand_cols)), ...
                     mean(depth_image(hand_region))]';
    result_score = mean(scores(hand_region));
end