function resu = pc_compute( D, pcs )
%resu = pc_compute( D, pcs )
% Principal compoment analysis of data matrix D
% Input:
% D    -- data matrix
% pcs  -- number of components
% Returns:
% resu -- a data structure with:
%   mu: mean of D
%   W:  eigen values
%   U:  eigen vectors
%   pinvU: pseudo-inverse of U

% Hugo Jair Escalante -- hugojair@inaoep.mx -- April, 2012

if nargin<2, pcs=10; end

    [p,n]=size(D);
    % center the data 
    resu.mu=mean(D,1);
    X=D-resu.mu(ones(p,1),:);    
    % Use singular value decomposition
    [XN,S,V] = svd(X, 'econ');
    S=diag(S);
    resu.W=S(1:pcs);
	resu.U=V(:,1:pcs)*diag(1./resu.W);    
    resu.pinvU=diag(resu.W)*V(:,1:pcs)';
    
end

