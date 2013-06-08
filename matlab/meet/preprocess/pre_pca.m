function [ X ] = pre_pca( X, params ) 
% pca( X ) 
%
% Input:
%   - X  : n-by-m matrix, n samples and m features
    cell_input = iscell(X.train);
    if cell_input
        [I.train, X.train] = seq2inst(X.train);
        [I.devel, X.devel] = seq2inst(X.devel);
        [I.test, X.test] = seq2inst(X.test);
    end        
    
    [ coeff_orth, num_dim ] = perform_pca( X.train, params.pca_variance );
    X.train = zscore(X.train)*coeff_orth;
    X.train = X.train(:,1:num_dim);
    
    X.devel = zscore(X.devel)*coeff_orth;
    X.devel = X.devel(:,1:num_dim);
    
    X.test  = zscore(X.test)*coeff_orth;
    X.test  = X.test(:,1:num_dim); 
    
    if cell_input
        X.train = inst2seq(I.train,X.train);
        X.devel = inst2seq(I.devel,X.devel);
        X.test = inst2seq(I.test,X.test);
    end
end

function [ coeff_orth, num_dim ] = perform_pca( X, pca_variance ) 
% [ coeff_orth, num_dim ] = perform_pca( X, pca_variance ) 
%
% Input:
%   - X
%   - pca_variance
% 
% Output:
%   - coeff_orth   : orthonormal basis
%   - num_dim

    % Perform PCA
    [wcoeff,~,~,~,explained] = pca(X, 'VariableWeights','variance');

    % Compute orthonormal coefficients of principle components
    coeff_orth = inv(diag(std(X)))*wcoeff;

    % Find the number of components that accounts for 95% of the variance
    a = find(floor(cumsum(explained))'==floor(pca_variance));
    num_dim = a(1);
end


