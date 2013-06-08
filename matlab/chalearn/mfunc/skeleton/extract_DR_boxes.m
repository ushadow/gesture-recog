function [bsx] = extract_DR_boxes(V0)
% [bsx] = extract_DR_boxes(V0)
% 
% Function to extract body parts information from a given video V0 using the
% articulated pose estimation code from  Deva Ramaman. 
% This code is publicly available from
% http://phoenix.ics.uci.edu/software/pose/
%
% In order to run this code you should install the aforementioned code.
%
% V0: is the video that will be labeled with body parts
%
% bsx:  Is a 3D matrix with dimension (n x m x k), where k is the number of 
%       frames in V0, n=18 is the number of boxes that are obtained, where
%       each box is associated to a articulation point in the body and m is the 
%       number of measurments that are stored for each frame and for each body
%       part. The stored measurements are the following as follows:
%           1 - x1 position of the box
%           2 - y1 position of the box
%           3 - x2 position of the box
%           4 - y2 position of the box
%           5 - x position of the center of the box
%           6 - y position of the center of the box
%           7 - area of the box
%
% Note: If you are running this under Mac, you will have to install mmread
%
% Isabelle Guyon -- isabelle@clopinet.com -- February 2012

% Load parameters file from Deva Ramaman's code
load BUFFY_final.mat   %%% upper body annotations
for ii=1:length(V0),
    IM=V0(ii).cdata;
    % Remove the background
    [IM, back, front]=bgcleanup( IM, 0, 0, 0);
    % Detect the boxes
    boxes = detect(IM, model, min(model.thresh,-1));
    boxes = nms(boxes, .2); % nonm  aximal suppression
    % Get coordinate info from the boxes
    [bsx(:,:,ii)]=showboxes2nd(boxes(1,:)); 
end  
end