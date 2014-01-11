function viewdictcluster(newX, X, subNdx, startImgNdx)
%%
% ARGS
% newX   - cell array
% X   - original data

newX = cell2mat(newX(subNdx));
alpha = newX(startImgNdx : end, :);

[~, labels] = max(alpha);
viewcluster(labels, 20, 5, X(subNdx), startImgNdx);

