function [M, M_AVERAGE, M_HISTORY, trail] = motion_trail(M, static)
%[M, M_AVERAGE, M_HISTORY, trail]  = motion_trail(M, static)
% This tracks motion in the image.
% M is a movie.
% static is a flag. If static==1, the static poses are tracked othewise the
% dynamic motion is tracked.
% Returns:
% M         -- a movie with the tracked poses or motion
% M_AVERAGE -- the average of the previous movie
% M_HISTORY -- a map with increasing indices trailing positive M values
% trail     -- a tempral sequence showing the average of each frame

% Isabelle Guyon -- isabelle@clopinet.com -- May 2012

if nargin<2, static=0; end

motion_detection_threshold=5;

ORIGINAL=double(M(1).cdata(:,:,1));
isd=is_depth(ORIGINAL);
if isd
    ORIGINAL=bgremove(ORIGINAL);
end

if length(M)==1
    M_AVERAGE=ORIGINAL;
    M_HISTORY=ORIGINAL;
    return
end

CURRENT=ORIGINAL;
NEXT=double(M(2).cdata(:,:,1));
if isd 
    NEXT=bgremove(NEXT);
end

M(1).cdata(:)=0;
num_frames=length(M);
[p, n, d]=size(ORIGINAL);
MOTION=zeros(p, n, num_frames);
trail=zeros(num_frames, 1);
    
for k=3:num_frames+1
    PREVIOUS=CURRENT;
    CURRENT=NEXT;
    NEXT=[];
    if length(M)>2 && k<=length(M)
        NEXT=double(M(k).cdata(:,:,1));
        if isd
            NEXT=bgremove(NEXT);
        end
    end
    if static
        MOTION(:,:,k-1)=static_posture(CURRENT, PREVIOUS, NEXT, ORIGINAL);
    else
        MOTION(:,:,k-1)=active_motion(CURRENT, PREVIOUS, NEXT, ORIGINAL);
    end
    trail(k)=mean(mean(MOTION(:,:,k-1)));
    M(k-1).cdata=uint8(MOTION(:,:,k-1));
    if isd
        M(k-1).colormap=gray(256);
    end
end

M_AVERAGE=mean(MOTION,3);

M_HISTORY=zeros(p,n);
for k=2:num_frames
    %idx=find(MOTION(:,:,k)>M_AVERAGE & M_HISTORY==0);
    idx=find(M_HISTORY==0 & MOTION(:,:,k)>motion_detection_threshold);
    M_HISTORY(idx)=MOTION(idx)+k;
end

end

