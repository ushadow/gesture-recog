function viewpointcloud(depth)
[X, Y] = meshgrid(1 : 64, 64 : -1 : 1);
X = X'; Y = Y';
X = X(:); Y = Y(:);
depthNdx = depth > 115;
X = X(depthNdx);
Y = Y(depthNdx);
scatter3(X, Y, depth(depthNdx), '.');
xlabel('X');
ylabel('Y');
zlabel('Z');
end