function s = euclid_simil( mat1, mat2, param )
%s = euclid_simil( mat1, mat2, param )
% Compute the negative Euclidean distance between all the examples of
% mat1 (dim p, n) and mat2 (dim m, m) and returns a matric (p, m)

% Isabelle Guyon -- isabelle@clopinet.com -- May 2012

if nargin<3 || isempty(param), param='euclid2'; end

%s = - norm(mat1(:)-mat2(:))

s = - svc_dp(param, mat1, mat2); % 'euclid' takes the sqrt

end

