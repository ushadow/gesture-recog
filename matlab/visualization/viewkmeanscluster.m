function viewkmeanscluster(newX, X, subNdx, startDescNdx)

newX = cell2mat(newX(subNdx));
labels = newX(end, :);
viewcluster(labels, 20, 5, X(subNdx), startDescNdx);

end