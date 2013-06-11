function X = resizeandcleanup(X, param)
%% RESIZEANDCLEANUP resizes the image features and cleansup the noises.

X = remapdepth(X);

if isfield(X, 'Tr')
  X1 = X.Tr;
else
  X1 = X;
end

origImgWidth = sqrt(double(size(X1{1}, 1) - param.startImgFeatNDX + 1));
X1 = resizeandfilter(X1, origImgWidth, param.imageWidth);

if isfield(X, 'Tr')
  X.Tr = X1;
else
  X = X1;
end

if isfield(X, 'Va')
  X.Va = resizeandfilter(X.Va, origImgWidth, param.imageWidth);
end

if isfield(X, 'Te')
  X.Te = resizeandfilter(X.Va, origImgWidth, param.imageWidth);
end

end

function X = resizeandfilter(X, origImgWidth, newWidth)
FILTER_WIN_SIZE = 3;
for i = 1 : length(X)
  seq = X{i};
  for j = 1 : size(seq, 2)
    v = seq(:, j);
    v = reshape(v, origImgWidth, origImgWidth);
    if (origImgWidth > newWidth)
      v = imresize(v, [newWidth newWidth]);
    end
    v = medfilt2(v, [FILTER_WIN_SIZE FILTER_WIN_SIZE]);
    seq(:, j) = reshape(v, [], 1);
  end
  X{i} = seq;
end
end