function x = normalize_length(x, k) 
% x = normalize_length(x, k) 
%   Normalize the length of x
%
% Input:
%   - x : m-by-1 vector or n-by-m matrix
%   - k : desired length
%
% Output:
%   - x : k-by-1 vector or n-by-k matrix

    colvec = size(x,2)==1;
    
    if colvec, x = x'; end
    [~, m] = size(x);
    idx = ceil((1:k)/k*m);
    x = x(:, idx);
    if colvec, x = x'; end
end