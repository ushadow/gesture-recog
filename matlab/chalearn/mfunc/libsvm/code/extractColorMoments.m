% function to color moments features from a list of image filenames
function[features] = extractColorMoments(folder, imageList,cat)


count = 0;

% loop over the images in the folder and extract their features
for i=1:size(imageList,1)
    try
        % read image and convert it to hsv colorspace
        imgRGB = imread(sprintf('%s/%s',folder,imageList(i,:)));
        count = count + 1;
        fprintf('%d %d\n',cat,count);
        imgHSV = rgb2hsv(imgRGB);
        
        % split image in 9 blocks and extract mean, variance and skewness
        % of each block
        [m n c] = size(imgHSV);

        features{count} = [];
        for k=1:3
            for j=1:3
                block = imgHSV( ceil((k-1)*m/3)+1:floor(k*m/3) , ceil((j-1)*n/3+1):floor(j*n/3) , : ) ;
           
                meanColor = mean(mean(block));
                varColor = var(var(block));
                skewColor = skewness(skewness(block));
                colorMomentsDescriptor = [meanColor(:)'  varColor(:)' skewColor(:)'];
                features{count} = [features{count} colorMomentsDescriptor];
               % subplot(3,3,(k-1)*3+j);
               % imshow(block);
            end
        end
    catch
    end
end