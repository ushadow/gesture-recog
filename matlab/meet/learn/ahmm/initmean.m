function [C, idx] = initmean(X, k)
%
% ARGS
% X   - cell array of matrices
%
% Returns:
% -C: a d x k matrix. Each column is the center of a cluster.

X = cell2mat(X);
d = size(X, 1);

tid = tic;
prm.outFrac = 0.1; prm.maxIter = 100; prm.rndSeed = 0;
% Change X to n x d.
X = X';
[~, C] = kmeans2(X, k, prm); 
fprintf('Done kmeans clustering %.2fs\n', toc(tid));

tid = tic;
options.MaxIter = 500; 
S.mu = C;
S.Sigma = repmat(eye(d) * 100, [1, 1, k]); 
S.PComponents = ones(1, k) / k;
obj = gmdistribution.fit(X, k, 'Start', S, 'Regularize', 0.01, 'Options', options);
fprintf('Done clustering %.2fs\n', toc(tid));
C = obj.mu';

if nargout > 1
  idx = cluster(obj, X);
end
end