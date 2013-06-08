function C = initmean(X, k)
% -X: cell array of cell array
%
% Returns:
% -C: a d x k matrix. Each column is the center of a cluster.

X = cell2mat(X);
prm.outFrac = 0.1; prm.nTrial = 3; prm.maxIter = 100; prm.rndSeed = 0;
[~, C] = kmeans2(X', k, prm); 
C = C';

% options = statset('MaxIter', 10);
% obj = gmdistribution.fit(X', k, 'CovType', 'diagonal', 'SharedCov', true, ...
%                          'Regularize', 0.01, 'Options', options);
% C = obj.mu';
end