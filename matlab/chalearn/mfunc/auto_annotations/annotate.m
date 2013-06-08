function [icoord, jcoord, kcoord, head_box, quality]=annotate(M, frame_num, use_kinect, debug)
%[icoord, jcoord, kcoord, head_box, quality]=annotate(M, frame_num, use_kinect, debug)

% Isabelle Guyon -- isabelle@clopinet.com -- February 2012

if nargin<2
    frame_num=1;
end
if nargin<3
    use_kinect=1;
end
if nargin<4
    debug=0;
end



% Initialize positions (uses the 2 first frame images)
IM1=M(frame_num).cdata;
if length(M)>1
    IM2=M(frame_num+1).cdata;
else
    IM2=[];
end
[icoord, jcoord, kcoord, head_box, quality] = ini_head_n_hands(IM1, IM2, use_kinect, debug);
if quality<0.8
    % Do it again, slow version
    [icoord, jcoord, kcoord, head_box, quality] = ini_head_n_hands(IM1, IM2, use_kinect, debug, 1);
end

%set(gcf, 'Name', ['Batch = ' num2str(batch_num)]);

% icoord(1), jcoord(1), kcoord(1): head coordinates (box center)
% head_box: head bounding box


% Does not work yet
%[gbeg, gend] = temporal_segmentation(M);

% Possible speedup for the head: in find_head, limit the convolution to the
% top of the head

% Ideas: use 3d coordinates to disambiguate head/hand position. Stop moving
% head and use only 2 clusters for heand when hands are close to head. Have
% a right and left tracker for the hand that is most right and that most
% left reagardless of hand crossing. 

% Main problem: when the hand slows down

end