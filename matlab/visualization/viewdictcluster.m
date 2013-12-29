function viewdictcluster(alpha, X, startImgNdx)
%%
% ARGS
% alpha   -
% X   - original data

N = 4;
SIZE = 16;

origImageWidth = sqrt(size(X{1}, 1) - startImgNdx + 1);

alpha = cell2mat(alpha);
X = cell2mat(X);
X = X(startImgNdx : end, :);

codebookSize = size(alpha, 1);
[~, labels] = max(alpha);
[~, topLabels] = sort(histc(labels, 1 : codebookSize), 'descend');
for i = 1 : 20
  subplot(4, 5, i);
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