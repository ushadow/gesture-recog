function analyzedepthimage(row_, column_range_)
% ANALYZE_DEPTH_IMAGE Analyzes and plots depth raw values from several 
% frames. 
%
% analyze_depth_images(row_, column_range_)
% row_: The row that to be ploted.
% column_range_ : The range of columns to be ploted.

column_range = 480 : 580;
row = 240;

if nargin >= 1
  row = row_;
  if nargin >= 2
    column_range = column_range_;
  end
end
  
dir_name = '../data/depth_raw/';

files = dir(dir_name);

all = [];
for i = 1 : length(files)
  file = files(i);
  if ~file.isdir
    M = dlmread([dir_name, file.name]);
    mid_row = M(row, :);
    all = [all; mid_row];
  end
end
max_depth = max(max(all));
bar3(-all(:, column_range) + max_depth, 'detached');
xlabel('Pixel position');
ylabel('Frame');
zlabel('Depth');
title(['Visualization of depth value. The higher the bar, the closer ', ... 
       'it is to the camera. Row = ', num2str(row), ' Column range = ', ...
       sprintf('%d:%d', column_range(1), column_range(end))]);
end