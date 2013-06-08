clear all; close all; clc;

absdatadir='C:\robot';

s=dir([absdatadir]); s=s(3:end);
dc=1;
for i=1:length(s),
    cdir=s(i).name;
    s2=dir([absdatadir '\' cdir '\std_cam\*jpg']);
    for j=1:length(s2),
        I=imread([absdatadir '\' cdir '\std_cam\rgb_' num2str(j) '.jpg']);
        M(:,:,j)=rgb2gray(I);
    end
end