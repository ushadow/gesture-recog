% find how to split the test images and detect the circles containing the
% letters

close all
clear all
clc

% reference correct split values to compute performances
verSplitRef = 160;
horSplitRef = 120;

showImage = 0;

% variables to store the errors
horErr = 0; % horizontal split error
verErr = 0; % vertical split error
circlErr = 0; % circle detection error

tic
% loop over the test images
for imageIndex=1:1 %200

    imageIndex

    I = imread(sprintf('./TestImages/challenge%d/challenge%d.jpg',imageIndex,imageIndex));

    % find edges based on Laplacian of Gaussian operator
    Igray = rgb2gray(I);
    Ibin = edge(Igray,'log');
    [m n] = size(Ibin);

    % histogram of vertical edges
    verSum = sum(Ibin);

    verSum(round(n/2)-1:round(n/2)+1) = 0; % to avoid having the middle line as candidate split

    % find vertical line containing the highest number of edges
    [maxVer1 loc1] = max(verSum);

    while((n/loc1)>10)
        verSum(loc1) = 0;
        [maxVer1 loc1] = max(verSum);
    end

    % keep the minimum value as for the split
    verSplit = min([(n-loc1) loc1]);

    % find horizontal line containing the highest number of edges
    horSum = sum(Ibin');

    horSum(round(m/2)-1:round(m/2)+1) = 0;

    [maxHor1 loc1] = max(horSum);

    horSplit = min([(m-loc1) loc1]);


    % adjusts the split values to be perfect dividends of the
    % image dimensions
    if(mod(n,verSplit)>0)
        verSplit = round(n/round(n/verSplit));
    end

    if(mod(m,horSplit)>0)
        horSplit = round(m/round(m/horSplit));
    end

    % computes the error with respect to the optimal values
    if(abs(verSplitRef-verSplit)>3)
        verErr = verErr+1;
        figure
        imshow(I);
        imageIndex
    end
    if(abs(horSplitRef-horSplit)>3)
        horErr = horErr+1;
        figure
        imshow(I);
        imageIndex
    end


    % split into subimages and find circular regions containing the letters

    count = 1;
    circenTOT = [];
    cirradTOT = [];

    superTOT = zeros(m,n,round(min([m/4,n/4])));
    
    % loop over each subimge
    for i=1:floor(m/horSplit)
        for j=1:floor(n/verSplit)
            
            Istack{count} = I((i-1)*m/floor(m/horSplit)+1:i*m/floor(m/horSplit),(j-1)*n/floor(n/verSplit)+1:j*n/floor(n/verSplit),:);
    
            IgrayTmp = Igray((i-1)*m/floor(m/horSplit)+1:i*m/floor(m/horSplit),(j-1)*n/floor(n/verSplit)+1:j*n/floor(n/verSplit),:);

            % compute the generalized Hough transform to detect circles in the image 
            [accum, circen, cirrad] = CircularHough_Grd(IgrayTmp, [15 25]);

            % erase candidate circles with radii<2 pixels
            index = find(cirrad<2);
            cirrad(index) = [];

            % populates the 3D histogram of possible circles (dimensions are y,x coordinates of the center and radius)
            for kk=1:length(cirrad)
                superTOT(round(circen(kk,1)),round(circen(kk,2)),round(cirrad(kk))) = superTOT(round(circen(kk,1)),round(circen(kk,2)),round(cirrad(kk)))+1;
            end
            
            count  = count+1;
        end
    end

    % find the maximum value in the 3D histogram, which corresponds to the
    % circle we are looking for. This is based on the (true) assumption that the
    % circle containing the letter occupies the same position in every
    % subimage
    [val bestLoc1] = max(superTOT);

    [val bestLoc2] = max(val);

    [val bestRadius] = max(val);

    bestCenterY = bestLoc1(1,bestLoc2(1,1,bestRadius),bestRadius);
    bestCenterX = bestLoc2(1,1,bestRadius);

    % computes the error wrt grpund truth values
    if(abs(bestCenterX-90)>3 || abs(bestCenterY-130)>3 || abs(bestRadius-19)>3)
        circlErr = circlErr+1;
    end

    % save binarized regions (squares inscribed in the detectd circles) contating the letters
    % these will be the input to the letter classifier
    count = 1;
    if(showImage)
        figure
    end
    for i=1:floor(m/horSplit)
        for j=1:floor(n/verSplit)
            Igray = rgb2gray(Istack{count});

            len = round(bestRadius/sqrt(2));
      %%%      imwrite(im2bw(imresize(Igray(bestCenterX-len:bestCenterX+len,bestCenterY-len:bestCenterY+len),[27 27]),0.6), ...
     %%%       sprintf('./images/challenge%d/letter%d.png', imageIndex,count));
      %%%      imwrite( Istack{count},sprintf('./images/challenge%d/image%d.png', imageIndex,count));

            if(showImage)
                subplot(floor(m/horSplit),floor(n/verSplit),count);
                imagesc(Igray); colormap('gray'); axis image;
                hold on;

                plot(bestCenterY, bestCenterX, 'r+');
                DrawCircle(bestCenterY, bestCenterX, bestRadius, 32, 'b-');
                len = round(bestRadius/sqrt(2));
                pointsY = [bestCenterY-len, bestCenterY-len, bestCenterY+len bestCenterY+len];
                pointsX = [bestCenterX-len, bestCenterX+len, bestCenterX+len bestCenterX-len];
                plot(pointsY,pointsX,'g');

                hold off;
            end
            count = count+1;
        end
    end

end
toc

% prints the errors
verErr
horErr
circlErr
