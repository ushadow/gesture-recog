function mu=average(X, A)
%mu=average(X, A)
% Weighted average of X with weights A
if nargin<2, 
    mu=mean(X);
    return
end

% Normalize weights
A=A./sum(A);

mu=sum(X.*A);
