function s = euclid_dist( mat1, mat2)
%s = euclid_simil( mat1, mat2)
% Compute the squared Euclidean distance between all the examples of
% mat1 (dim p, n) and mat2 (dim m, m) and returns a matric (p, m)

% Isabelle Guyon -- isabelle@clopinet.com -- May 2012

param='euclid2'; 

s = - svc_dp(param, mat1, mat2); % 'euclid' takes the sqrt

end

