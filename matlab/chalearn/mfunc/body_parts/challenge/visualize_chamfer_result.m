function result = visualize_chamfer_result(edge_image, in_template, scores, scales, y, x)

% result = visualize_chamfer_result(edge_image, template, scores, scales, x, y)

scale = scales(y, x);
in_template = double(in_template);
template = imresize(in_template, scale, 'bilinear');

[irows, icols] = size(edge_image);
[trows, tcols] = size(template);
half_rows = floor(trows / 2);
half_cols = floor(tcols / 2);
padding = ceil(.2 * max(trows, tcols));
rrows = 2 * half_rows + 2*padding + 1;
rcols = 2 * half_cols + 2*padding + 1;

ctop = max(1, y - half_rows - padding);
cbottom = min(y + half_rows + padding, irows);
cleft = max(1, x - half_cols - padding);
cright = min(x + half_cols + padding, icols);
cropped = edge_image(ctop:cbottom, cleft:cright);
[crows, ccols] = size(cropped);

ftop = max(1, half_rows + padding - y);
fbottom = ftop + crows - 1;
fleft = max(1, half_cols + padding - x);
fright = fleft + ccols - 1;
first = zeros(rrows, rcols);
first((ftop:fbottom), (fleft:fright)) = cropped;

second = zeros(rrows, rcols);
second((padding+1):(padding+trows), (padding+1):(padding+tcols)) = template;

result = zeros(rrows, rcols, 3);
result(:,:,1) = first;
result(:,:,2) = (second ~= 0) * 255;
imshow(result);


