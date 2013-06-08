% function to extract gist features from a list of image filenames
function[features] = extractGistFeatures(folder, imageList,cat)

% keep default parameters
% % % param.imageSize = gistParameters(1);
% % % param.orientationsPerScale = gistParameters(2:5);
% % % param.numberBlocks = gistParameters(6);
% % % param.fc_prefilt = gistParameters(7);

count = 0;

% loop over the images in the folder and extract their features
for i=1:size(imageList,1)
    try
        % read image and convert it to hsv colorspace
        
        img = imread(sprintf('%s/%s',folder,imageList(i,:)));
        
        count = count + 1;
        fprintf('%d %d\n',cat,count);

        % Computing gist:
        [features{count}, param] = LMgist(img, ''); % param

    catch
    end
end


