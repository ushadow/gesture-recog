function [average, eigenvectors, eigenvalues] = compute_pca(vectors)

% function [average, eigenvectors, eigenvalues] = compute_pca(vectors)
 
number = size(vectors, 2);
% note that we are transposing twice
average = [mean(vectors')]';
centered_vectors = zeros(size(vectors));

for index = 1:number
    centered_vectors(:, index) = vectors(:, index) - average;
end

covariance_matrix = centered_vectors * centered_vectors';
[eigenvectors eigenvalues] = eig( covariance_matrix);

% eigenvalues is a matrix, but only the diagonal matters, so we throw
% away the rest
eigenvalues = diag(eigenvalues);
[eigenvalues, indices] = sort(eigenvalues, 'descend');
eigenvectors = eigenvectors(:, indices);



