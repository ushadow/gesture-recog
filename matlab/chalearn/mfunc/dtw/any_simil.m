function s = any_simil( mat1, mat2, param )
%s = any_simil( mat1, mat2, param )
% Compute a similarity between all the examples of
% mat1 (dim p, n) and mat2 (dim m, m) and returns a matric (p, m)

% Isabelle Guyon -- isabelle@clopinet.com -- May 2012

if nargin<3, param='euclid2'; end

if strcmp(param, 'euclid') || strcmp(param, 'euclid2') 
	sgn=-1;
else
	sgn=1;
end

s = sgn * svc_dp(param, mat1, mat2); 

end

