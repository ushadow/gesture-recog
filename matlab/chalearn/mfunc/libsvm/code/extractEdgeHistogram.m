% function to extract features from a list of image filenames
function[features] = extractEdgeHistogram(folder, imageList,cat)

count = 0;

% loop over the images in the folder and extract their features
for i=1:size(imageList,1)
    try
    % read image and convert it to grayscale
    imgRGB = imread(sprintf('%s/%s',folder,imageList(i,:)));
    count = count + 1;
    fprintf('%d %d\n',cat,count);
    imgGray = rgb2gray(imgRGB);

    % split image in 24 blocks and compute the number of edges in each
    % block, normalized by the size of the block

    [m n] = size(imgGray);
    
    imgEdge = edge(imgGray,'log');

    features{count} = [];
    for k=1:6
        for j=1:8
            block = imgEdge( ceil((k-1)*m/6)+1:floor(k*m/6) , ceil((j-1)*n/8+1):floor(j*n/8) , : ) ;
            [h w] = size(block);
            edgeCount = sum(sum(block))/(h*w/4);
            features{count} = [features{count} edgeCount];
        end
    end
    
    catch
    end
end
