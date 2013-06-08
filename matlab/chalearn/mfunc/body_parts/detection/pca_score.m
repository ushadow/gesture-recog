function result = pca_score(window, mean_face, ...
                            eigenvectors, eigenface_number)

% function result = pca_score(window, mean_face, eigenvectors, eigenface_number)

% normalize the window
window = imresize(window, size(mean_face), 'bilinear');
window = window(:);
window = window - mean(window);
window = window / std(window);
window(isnan(window)) = 0;

top_eigenvectors = eigenvectors(:, 1:eigenface_number);
projection = pca_projection(window, mean_face, top_eigenvectors);
reconstructed = pca_backprojection(projection, mean_face, top_eigenvectors);

diff = reconstructed - window(:);
result = sum(diff .* diff);
