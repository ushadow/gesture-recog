function testsvdeig(X)

fprintf('svd');
tic;
svd(X' * X);
toc;
fprintf('eig');
tic;
[V, D] = eig(X' * X);
sort(diag(D), 'descend');
toc;
end