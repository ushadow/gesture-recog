function result = pca_projection(vector, average, eigenvectors)

% function result = pca_projection(vector, average, eigenvectors)
%
% the vector is converted to a column vector. Each column in eigenvectors should
% be an eigenvector. The mean is converted to a column vector
 
% subtract mean from vector
centered = vector(:) - average(:);

% convert vector to a column vector.
centered = centered(:);
result = eigenvectors' * centered;
