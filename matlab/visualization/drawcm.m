function drawcm(mat, tick)
%%
% Matlab code for visualization of confusion matrix;
% Parameters£ºmat: confusion matrix;
% tick: name of each class, e.g. 'class_1' 'class_2'...
% num_class: number of class
%
% Blog: www.shamoxia.com;
% QQ:379115886;
% Email: peegeelee@gmail.com
%%

figure;
nclass = length(tick);
imagesc(1 : nclass, 1 : nclass, mat); %# in color
colormap(flipud(hot));

textStrings = num2str(mat(:),'%0.0f');
textStrings = strtrim(cellstr(textStrings));

[x,y] = meshgrid(1 : nclass);
hStrings = text(x(:),y(:),textStrings(:), 'HorizontalAlignment','center');
midValue = mean(get(gca,'CLim'));
textColors = repmat(mat(:) > midValue,1,3);
set(hStrings,{'Color'},num2cell(textColors,2)); %# Change the text colors

set(gca,'xticklabel',tick, 'XAxisLocation', 'bottom', 'FontSize', 12);
set(gca, 'XTick', 1 : nclass, 'YTick', 1 : nclass);
set(gca,'yticklabel',tick, 'FontSize', 12);
ylabel('ground truth', 'FontSize', 14);
xlabel('prediction', 'FontSize', 14);
