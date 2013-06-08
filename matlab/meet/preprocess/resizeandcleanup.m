function data = resizeandcleanup(data, param)
%% RESIZEANDCLEANUP resizes the image features and cleansup the noises.

FILTER_WIN_SIZE = 3;

X = remapdepth(data.X);
origImgWidth = sqrt(size(X{1}, 1) - param.startImgFeatNDX + 1);

for i = 1 : length(X)
  seq = X{i};
  for j = 1 : size(seq, 2)
    v = seq(:, j);
    if ( origImgWidth > param.imageWidth)
      v = reshape(v, n, n);
      v = imresize(v, [newSize newSize]);
    end
    v = medfilt2(v, [FILTER_WIN_SIZE FILTER_WIN_SIZE]);
    seq(:, j) = reshape(v, [], 1);
  end
  X{i} = seq;
end

data.X = X;
end