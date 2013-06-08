function I = depthclose(depthImage)
  I = depthmorph(depthImage, 'dilate');
  I = depthmorph(I, 'erode');
end

function I = depthmorph(image, op)
w = 3;
hw = floor(w / 2);
[nrow ncol] = size(depthImage);
I = zeros(nrow, ncol);
for x = 1 : nrow
  for y = 1 : ncol
    minx = min([1 x - hw]);
    maxx = max([nrow x + hw]);
    miny = min([1 y - hw]);
    maxy = max([ncol y + hw]);
    switch op
      case 'dilate'
        fun = @max;
      case 'erode'
        fun = @min;
      otherwise
        error(['Wrong operation: ' op]);
    end
    I(x, y) = fun(fun(image(minx : maxx, miny : maxy)));
  end
end
end