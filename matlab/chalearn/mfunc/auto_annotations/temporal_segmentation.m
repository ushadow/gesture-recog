function [gbeg, gend] = temporal_segmentation(M)
%[gbeg, gend] = temporal_segmentation(M)
% M    -- Movie (RGB of Kinect depth)
% gbeg -- List of starting points of the gesture
% gend -- List of end points of the gesture

debug=1;
debug2=0;

gbeg=[];
gend=[];

% Reduce the resolution 
factor=0.25;
for k=1:length(M)
    M(k).cdata=imresize(M(k).cdata, factor);
end

if debug2, play_movie(M); end

[icoord, jcoord]=track(M);
%kcoord=get_k(M, icoord, jcoord);
MDO=overlay(M, icoord, jcoord, kcoord);

if debug, play_movie(MDO); end

end

