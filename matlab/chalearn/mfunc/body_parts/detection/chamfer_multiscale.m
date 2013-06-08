function [scorestoim, scorestotemp, best_scales] = chamfer_multiscale(edge_image, template, scales)

% function result = chamfer_multiscale(edge_image, template, scales)
%
% small scales mean find smaller instances (we scale down the template)

[rows, cols] = size(edge_image);
desired_rows = 120;
desired_cols = 160;
factor1 = desired_rows / rows;
factor2 = desired_cols / cols;

sample_rate = min(factor1, factor2);

edge_image2 = imresize(edge_image, sample_rate, 'bilinear');
edge_image = double(edge_image2 > 0.13);

template = double(template);
template2 = imresize(template, sample_rate, 'bilinear');
template = double(template2 > 0.13);

[rows, cols] = size(edge_image);
scores = zeros(rows, cols) + inf;
scorestoim = zeros(rows, cols) + inf;
scorestotemp = zeros(rows, cols) + inf;
best_scales = zeros(rows, cols);

a = bwlabel(~(imdilate(template, ones(3,3))), 4);
ft_interior = double(a == 2);
template_dt = double(bwdist(template));
template_dt = template_dt .* ft_interior;

distance_transform = bwdist(edge_image);

exponent = 5;
distance_transform = distance_transform .^ exponent;

for scale = scales
  if (scale < 1)
    resized_template = imresize(template, scale, 'bilinear');
    resized_template = double(resized_template > 0.23);
  else
    resized_template = imresize(template, scale, 'nearest');
  end
  
  resized_interior = imresize(ft_interior, scale, 'nearest');
  resized_template_dt = imresize(template_dt, scale, 'nearest');
  resized_template_dt = resized_template_dt .^ exponent;
  
  number = sum(resized_template(:));
  temp_scores = chamfer_distance2(distance_transform, resized_template);
  temp_scores = (temp_scores / number) / (scale ^ exponent);
  
  interior_edges = imfilter(edge_image, resized_interior, 'same', 1);
  interior_edges(interior_edges == 0) = 1;
  other_direction = imfilter(edge_image, resized_template_dt, 'same', 1);
  other_direction = (other_direction ./ interior_edges);
  
  sel = (other_direction < temp_scores);
  other_direction(sel) = temp_scores(sel);
  
  total_scores = temp_scores + other_direction;
  
  selected = (total_scores < scores);
  best_scales(selected) = scale;
  scorestoim(selected) = temp_scores(selected);
  scorestotemp(selected) = other_direction(selected);
  scores(selected) = total_scores(selected);
end

scorestoim = imresize(scorestoim, 1/sample_rate, 'nearest');
scorestotemp = imresize(scorestotemp, 1/sample_rate, 'nearest');
best_scales = imresize(best_scales, 1/sample_rate, 'nearest');
