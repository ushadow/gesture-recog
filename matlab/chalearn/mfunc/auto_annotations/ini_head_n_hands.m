function [icoord, jcoord, kcoord, head_box, quality] = ini_head_n_hands( IM, IM2, use_kinect, debug, slow_version )
%[icoord, jcoord, kcoord, head_box, quality] = ini_head_n_hands( IM, IM2, use_kinect, debug, slow_version )
% Find coordinates of head and hands (kcoord is either the depth or red)
% and the head bounding box.
% Input:
% IM     --- First frame image
% IM2    --- Second frame image
% use_kinect -- former versions worked also for RGB images
% debug -- show images is >0
% slow_version -- takes more time to cleanup the background
% Returns:
% [icoord, jcoord, kcoord] --- First values: Head coordinates, 
% following 2 values: hand coordinates (tentative, ignore).

% This is a very simple emthod based on differences between an image and
% the same image shifted and differences between consecutive frames.

% Isabelle Guyon -- isabelle@clopinet.com -- Feb. 2011

if nargin<3
    use_kinect=1;
end
if nargin<4
    debug=1;
end
if nargin<5, 
    slow_version=0;
end

if debug>1
    tic
end

%% Compute R1 and R2
% Diffence of first and second images (red channel only to save time when not in debug mode)
% We pass to double so we can make differences in absolute value
if use_kinect
    add_top=1;
    % Cleanup the background to remove far away stuff and noise
    % In the first line, if the head is cut off, add a top background line
    % in the first frame to be able to detect the head ("add_top")
    if debug<2
        R1=double(bgcleanup(IM(:,:,1), 0, add_top, slow_version));
    else
        % In debug mode, process the whole image, not just the R channel
        % for visualization purpose
        R1=bgcleanup(IM, 1, add_top, slow_version); R1=double(R1(:,:,1));
    end
    [R2, back, front]=bgcleanup(IM2(:,:,1), 0, 0, slow_version);
    R2=double(R2);
else
    R1=double(IM(:,:,1));
    R2=double(IM2(:,:,1));
    back=0; front=0;
end

[L, C]=size(R1); % L lines, C columns

if isempty(IM2)
    DRA=[];
else
    % Difference between consecutive images
    DRA=abs(R2-R1);
    DRA=conv2(DRA, [1 1 1]/3, 'same');
    DRA=conv2(DRA, [1 1 1]/3', 'same');
end
% Difference between shifted images hirizontally and vertically
DRB0=abs(R1(1:end-1,:)- R1(2:end,:));
DRB=[zeros(1,C); DRB0]+[DRB0; zeros(1,C)];

%DRB=[zeros(1,C); abs(R1(1:end-1,:)- R1(2:end,:))];
%DRB=conv2(DRB, [1 1 1], 'same');
%DRB=conv2(DRB, [1 1 1]', 'same');
% Difference between shifted images horizontally
%DRC=[zeros(L,1), abs(R1(:,1:end-1)- R1(:, 2:end))];
DRC0=abs(R1(:,1:end-1)- R1(:, 2:end));
DRC=[zeros(L,1),DRC0]+[DRC0, zeros(L,1)];
%DRC=conv2(DRC, [1 1 1], 'same');
%DRC=conv2(DRC, [1 1 1]', 'same');

% Indices of the image coordinates
i=[1:L]';
j=1:C;
I=i *ones(1,C); 
J=ones(L,1)*j; 
I=I(:);
J=J(:);

% Initial most moving points
% Find the center of gravity of motion on the top part
if debug>1
    fprintf('0 ==> %5.4f\n',  toc);
    tic
end

% This peice of code is obsolete
if 1==2
    gi=find(DRA>1);
    md=sum(DRA(gi));
    muI=round(sum(I(gi).*DRA(gi))/md);
    gi=intersect(find(I<=muI), gi);
    md=sum(DRA(gi));
    muJ=round(sum(J(gi).*DRA(gi))/md);
end

if debug>1
    fprintf('1 ==> %5.4f\n',  toc);
    tic
end

% Find the center of gravity of closest points in projection on x
rsum=mean(R1);
[r, muJ]=min(rsum(10:end-10)); % There is sometimes noise in the first and last colums

for epsi=[6 5 4 3 2 1 0]

    if isempty(DRA)
        ii=find(DRB>epsi | DRC>epsi);
    else
        ii=find(DRA>0 & (DRB>epsi | DRC>epsi));
    end

    IC=I(ii);
    JC=J(ii);

    % Find the top body moving point(s) in the middle part -- where the head usually is
    idx=find(IC<=2*L/3 & JC>muJ-C/4 & JC<muJ+C/4);
    %idx = 1:length(IC);
    if length(idx)>C, break; end
end
if isempty(idx)
    [val, idx]=min(IC);
end
IC0=IC(idx);
JC0=JC(idx);

if debug>1;
    fprintf('2 ==> %5.4f\n',  toc);
    tic
end

if debug>1;
    IM0=IM;
    for k=1:length(IC0)
        IM0(IC0(k), JC0(k),1)=255;
    end
    figure; imagesc(IM0);
end

if debug, fprintf('num points=%d\n', length(idx)); end

% Sort the points to get those in the top lines
[rr, iii]=sort(IC0); 

% Coord of the top of the green box (take into account top ten percent)
mmax=min(length(iii), max(10, floor(length(iii)/10)));
ICT=IC0(iii(1:mmax));
JCT=JC0(iii(1:mmax));
ict=median(ICT);
jct=median(JCT);

if debug>1;
    fprintf('3 ==> %5.4f\n',  toc);
    tic
end

% Coord of the left and right sides of the box
if L<100
    delta=1; % This is the amount that gets shaved inside
else
    delta=2;
end
iidx=iii(mmax+1:min(5*mmax, length(iii)));
ICA=IC0(iidx); % all points right and left
JCA=JC0(iidx); % all points right and left
idxl=find(JCA<=jct-2*delta); % left points 
idxr=find(JCA>=jct+2*delta); % right points
if isempty(idxl)
    JCL=min(JC0);
else
    JCL=JCA(idxl);
end
if isempty(idxr)
    JCR=max(JC0);
else
    JCR=JCA(idxr); 
end
jcl=median(JCL); % left of green box
jcr=median(JCR); % right of green box

if debug >1
    IM0=IM;
    ICA=IC0(iidx);
    ICL=ICA(idxl);
    ICR=ICA(idxr); 
    for k=1:length(ICT)
        IM0(ICT(k), JCT(k),1)=255;
    end
    for k=1:length(ICL)
        IM0(ICL(k), JCL(k),2)=255;
    end
    for k=1:length(ICR)
        IM0(ICR(k), JCR(k),3)=255;
    end
    figure; imagesc(IM0);
end

if debug>1;
    fprintf('4 ==> %5.4f\n',  toc);
    tic
end

% Iterate a couple of times to get rid of outliers
for k=1:2
    % width and height
    w=jcr-jcl;  % The width of the box
    h=1.5*w;    % The height is just 3/2 ht width
    
    if ~isempty(idxl)
        idxl=intersect(idxl, find((JCA>jcl-2*delta | ICA<ict+h/2) & JCA<jcl+w/2-delta)); % left points
        if ~isempty(idxl)
            JCL=JCA(idxl);
            jcl=median(JCL); % left of green box
        end
    end
    if ~isempty(idxr)
        idxr=intersect(idxr, find((JCA<jcr+2*delta | ICA<ict+h/2) & JCA>jcr-w/2+delta)); % right points
        if ~isempty(idxr)
            JCR=JCA(idxr); 
        jcr=median(JCR); % right of green box
        end
    end
end

% width and height
w=jcr-jcl;  % The width of the box
h=min(1.5*w, L-ict);    % The height is just 3/2 ht width
head_box=[jcl ict w h];

% head center
icoord(1)=ict+h/2;
jcoord(1)=jcl+w/2;

if debug>1;
    fprintf('5 ==> %5.4f\n',  toc);
end

if debug
    ICA=IC0(iidx);
    ICL=ICA(idxl);
    ICR=ICA(idxr); 
    for k=1:length(ICT)
        IM(ICT(k), JCT(k),1)=255;
    end
    for k=1:length(ICL)
        IM(ICL(k), JCL(k),2)=255;
    end
    for k=1:length(ICR)
        IM(ICR(k), JCR(k),3)=255;
    end
    figure; imagesc(IM);
    hold on
    rectangle('Position', head_box, 'EdgeColor', 'g');
    plot(jcoord(1), icoord(1), 'g*');
end

% Check the quality of what we found
mean_box=mean(mean(R1(round(ict):round(ict+h), round(jcl):round(jcl+w))));
quality=1-min(max(0, (mean_box-front)/(back-front)), 1);
if debug
    fprintf('mean_box=%5.2f, back=%5.2f, front=%5.2f, quality=%5.2f\n', mean_box, back, front, quality);
end

% TENTAVIVE HAND POSITION INITIALIZATION (ignore)

% Find the lower body moving point(s)
idx=find(IC>L/2);
if isempty(idx)
    [val, idx]=max(IC);
end
IC0=IC(idx);
JC0=JC(idx);

if debug>1
    for k=1:length(IC0)
        IM(IC0(k), JC0(k),1)=255;
    end
    figure; imagesc(IM);
end

% Find center of gravity of right hand
idx=find(JC0<jcoord(1)); % right side of head
if isempty(idx)
    [val, idx]=min(JC0);
end
IC=IC0(idx);
JC=JC0(idx);
icoord(2)=median(IC);
jcoord(2)=median(JC);

if debug>1
    for k=1:length(IC)
        IM(IC(k), JC(k),1)=255;
    end
    IM(round(icoord(2)), round(jcoord(2)),2)=255;
    figure; imagesc(IM);
end

% Find center of gravity of left hand
idx=find(JC0>jcoord(1));
if isempty(idx)
    [val, idx]=max(JC0);
end
IC=IC0(idx);
JC=JC0(idx);
icoord(3)=median(IC);
jcoord(3)=median(JC);

if debug>1
    for k=1:length(IC)
        IM(IC(k), JC(k),1)=255;
    end
    IM(round(icoord(3)), round(jcoord(3)),2)=255;
    figure; imagesc(IM);
end

kcoord=get_k(IM, icoord, jcoord);

end

