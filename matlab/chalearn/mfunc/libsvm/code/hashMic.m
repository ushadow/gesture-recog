
clc
clear all 
close all


fid  = fopen('testCategories.txt');
tline = fgetl(fid);
tline = fgetl(fid);
i=0;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    i=i+1;
    concepts{i} = tline(1:end-4);
end
fclose(fid);
% descriptorMic = zeros(13000,9);
count = 0;
tic
for i=1:5 %length(concepts)
   
    imageList = ls(sprintf('./trainingSet/%s/',concepts{i}));
    imageList(1:3,:) = [];
    
    for j=1:size(imageList,1)
        count = count + 1
        imageNames{count} = sprintf('./trainingSet/%s/%s',concepts{i},imageList(j,:));
        Im = rgb2gray(double(imread(imageNames{count}))/255);
        [m n] = size(Im);
        for y=1:3
            for x=1:3
                block = Im( ceil((y-1)*m/3)+1:floor(y*m/3) , ceil((x-1)*n/3+1):floor(x*n/3) ) ;
                descriptorMic(count,(y-1)*3+x) = mean(mean(block));
            end
        end
    end
end
   toc
   close all
   found=[];
for i=1:2000 %size(descriptorMic,1)
    i
    if(length(find(found==i))==0)

    res = sum(abs(descriptorMic-repmat(descriptorMic(i,:),500,1)),2); %sum, ,2
    index = find(res<0.02);
    in = find(index==i);
    index(in)= [];
    if(length(index)>0)
        found = [found; index];
        figure
        subplot(1,length(index)+1,1)
        I = imread(imageNames{i});
        imshow(I);
        title(imageNames{i});
        for j=1:length(index)
            subplot(1,length(index)+1,j+1)
            I = imread(imageNames{index(j)});
            imshow(I);
            title(imageNames{index(j)});
        end
    end
    end
end
% %     [wavelet delta level numrects] = getParamsDWT(1);
% %     key = 101;
% % 
% %     dimn1 = size(img1);
% %     dimn2 = size(img2);
% % 
% %     dim = dimn1(1); % optimize based on that assumption
% % 
% %     if length(dimn1) > 2
% %         img1 = rgb2gray(img1);
% %         img1 = imresize(img1, [dim dim]);
% %     else
% %         img1 = imresize(img1, [dim dim]);
% %     end
% % 
% %     if length(dimn2) > 2
% %         img2 = rgb2gray(img2);
% %         img2 = imresize(img2, [dim dim]);
% %     else
% %         img2 = imresize(img2, [dim dim]);
% %     end
% % 
% %     hashVec1 = wavelethash(double(img1), wavelet, delta, key, level, numrects);
% %     hashVec2 = wavelethash(double(img2), wavelet, delta, key, level, numrects);
% % 
% %     v = (hashVec1 - hashVec2)/(2*sqrt(norm(hashVec1)*norm(hashVec2)));
% % 
% %     % Threshold
% %     tau = 0.08;
% % 
% %     if (norm(v) < tau)
% %         norm(v)
% %         disp('Verdict: Image and distorted version');
% %     else
% %         norm(v)
% %         disp('Verdict: Different Images');
% %     end
% % 
% %     figure;
% %     subplot(1,2,1); imshow(img1); title('Reference Image');
% %     subplot(1,2,2); imshow(img2); title('Query Image');

