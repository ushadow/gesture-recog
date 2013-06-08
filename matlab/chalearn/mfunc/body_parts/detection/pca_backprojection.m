function result = pca_backprojection(projection, average, eigenvectors)

% function result = pca_backprojection(vector, average, eigenvectors)
%
% the vector is converted to a column vector. Each column in eigenvectors should
% be an eigenvector. The mean is converted to a column vector
 
projection = projection(:);
centered_result = eigenvectors * projection;
result = centered_result + average(:);
