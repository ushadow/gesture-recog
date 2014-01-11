function viewcluster(labels, nClusters, nCols, X, startImgNdx)

N = 4;
SIZE = 16;

nRows = ceil(nClusters / nCols);
[~, topLabels] = sort(histc(labels, 1 : max(labels)), 'descend');

origImageWidth = sqrt(size(X{1}, 1) - startImgNdx + 1);
X = cell2mat(X);
X = X(startImgNdx : end, :);

for i = 1 : nClusters
  subplot(nRows, nCols, i);
  I = find(labels == topLabels(i));
  image = zeros(N * SIZE, N * SIZE);
  for r = 1 : N
    for c = 1 : N
      ndx = N * (r - 1) + c;
      if ndx > numel(I), break; end
      rowNdx = (r - 1) * SIZE + 1 : r * SIZE;
      colNdx = (c - 1) * SIZE + 1 : c * SIZE;
      patch = reshape(X(:, I(ndx)), origImageWidth, origImageWidth)';
      image(rowNdx, colNdx) = imresize(patch, [SIZE SIZE]);
    end
  end
  imshow(mat2gray(image));
end
end