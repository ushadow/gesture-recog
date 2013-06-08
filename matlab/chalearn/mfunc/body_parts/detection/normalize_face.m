function result = normalize_face(image_window, mean_face)

% function result = normalize_face(vector)
%
% normalizes the vector so that the size matches that of
% mean face, the mean is 0 and the std is 1.

result = imresize(image_window, size(mean_face), 'bilinear');
result = result(:);
result = result - mean(result(:));
result = result / std(result(:));
result(isnan(result)) = 0;
