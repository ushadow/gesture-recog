function [IM, back, front]=bgcleanup( IM, debug, addframe, slow_clean )
%[IM, back, front]=bgcleanup( IM, debug, addframe, slow_clean )
% Saturate the background to a maximum distance and remove noise.
% Works on Kinect data only.
% Works both for RGB images and back and white (single channel).
% debug =1, flag to show image
% addframe: add a frame of bag pixels on top line

% Isabelle Guyon -- isabelle@clopinet.com -- February 2012

if nargin<2
    debug=0;
end
if nargin<3
    addframe=0;
end
if nargin<4
    slow_clean=0;
end

epsi=5;
back_max=255;

% Red channel only
R=IM(:,:,1);
[L, C]=size(R); % L lines, C columns
if L<100
    clean_level=2;
else
    clean_level=3;
end

% max out the zeros because same are in the background
R(R==0)=(back_max+1)/2-1;

% Find the background 
%[rr, ii]=sort(R(:));
%away=round(length(rr)/2);
%back=rr(away);
%back=median(R(:));
back=round(mean(R(:)));

back_max=back;
% Indices of the image coordinates
i=[1:L]';
j=1:C;
I=i *ones(1,C); 
J=ones(L,1)*j; 
I=I(:);
J=J(:);

%Find the far away points (because of compression, not the same in all
%channels)
idxbad=[];
for i=1:size(IM, 3)
    im=IM(:,:,i);
    idxbad=[idxbad; find(im>back)];
end

% Max out the zeros and small values
idxz=[];
for i=1:size(IM, 3)
    im=IM(:,:,i);
    idxz=[idxz; find(im<epsi)];
end
for i=1:size(IM, 3)
    im=IM(:,:,i);
    im(idxz)=back_max;
    IM(:,:,i)=im;
end

% Replace the far away and their immediate neighbors
% (because due to compression side effects the neighbors are corrupted)

if clean_level==1 | ~slow_clean
    for i=1:size(IM, 3)
        im=IM(:,:,i);
        im(idxbad)=back_max;
        IM(:,:,i)=im;
    end
end
if slow_clean
    if clean_level>1
        for k=1:length(idxbad)
            i0=I(idxbad(k));
            j0=J(idxbad(k));
            i1=min(I(idxbad(k))+1, L);
            im1=max(I(idxbad(k))-1, 1);
            j1=min(J(idxbad(k))+1, C);
            jm1=max(J(idxbad(k))-1, 1);

            IM(im1, jm1, :)=back_max;
            IM(im1, j0, :)=back_max;
            IM(im1, j1, :)=back_max;

            IM(i0, jm1, :)=back_max;
            IM(i0, j0, :)=back_max;
            IM(i0, j1, :)=back_max;

            IM(i1, jm1, :)=back_max;
            IM(i1, j0, :)=back_max;
            IM(i1, j1, :)=back_max;

            if clean_level==3
                i2=min(I(idxbad(k))+2, L);
                im2=max(I(idxbad(k))-2, 1);
                j2=min(J(idxbad(k))+2, C);
                jm2=max(J(idxbad(k))-2, 1);

                IM(im2, jm2, :)=back_max;
                IM(im2, jm1, :)=back_max;
                IM(im2, j0, :)=back_max;
                IM(im2, j1, :)=back_max;
                IM(im2, j2, :)=back_max;

                IM(im1, jm2, :)=back_max;
                IM(im1, j2, :)=back_max;

                IM(i0, jm2, :)=back_max;
                IM(i0, j2, :)=back_max;

                IM(i1, jm2, :)=back_max;
                IM(i1, j2, :)=back_max;

                IM(i2, jm2, :)=back_max;
                IM(i2, jm1, :)=back_max;
                IM(i2, j0, :)=back_max;
                IM(i2, j1, :)=back_max;
                IM(i2, j2, :)=back_max;
            end

        end
    end
end
if addframe
    for k=1:2
        topl=IM(k,:,:);
        topl(topl<0.8*back_max)=(back_max+1)/k-1;
        IM(k,:,:)=topl;
    end
end

% Erase the first two column
IM(:,1:2,:)=back_max;

front=mean(IM(IM<back_max));

if debug
    figure; image(IM);
end

end

