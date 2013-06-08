function result = hough_demo(image, threshold, result_number)

% function result = hough_demo(image, threshold, results)
%
% calls canny(image, threshold), does hough transform on the resulting edge
% image, and draws the top "result_number" results.

image = double_gray(image);
edges = canny(image, threshold);
[h theta rho] = hough(edges);

result = image * 0.7;
for i = 1:result_number
    max_value = max(max(h));
    [rho_indices, theta_indices] = find(h == max_value);
    rho_index = rho_indices(1);
    theta_index = theta_indices(1);
    distance = rho(rho_index);
    angle = theta(theta_index);
    result = draw_line2(result, distance, angle);
    h(rho_index, theta_index) = 0;
end

    