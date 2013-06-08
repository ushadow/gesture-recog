function [icoord, jcoord]=track(DM, n, m)
%[icoord, jcoord]=track(DM, n, m)
% Take a movie of differences and track the coordinates
% of the largest difference.
% DM    --- Movie of consecutive frame differences
% n     --- number of moving points being considered
% m     --- number of closest pointsto the previous point over which the median is taken
%           m <=n. Increase m to reduce the damping.
% [icoord, jcoord] -- matrices with movie-length lines and up to 3 columns
% for the three main moving points (head and right+left)

% Isabelle Guyon -- isabelle@clopinet.com -- Dec. 2011

debug=0;

[L, C]=size(DM(1).cdata(:,:,1));

if nargin<2, n=round(L*C/100); end
if nargin<3, m=round(max(n/20, 5)); end
if m>n, m=n; end

% Initialize positions
[icoord, jcoord, head_box] = ini_head_n_hands(DM);

if debug
    MDO=overlay(DM(1), icoord, jcoord);
    figure; imagesc(MDO(1).cdata);
    hold on
    rectangle('Position', head_box, 'EdgeColor', 'g');
end

% Indices of the image coordinates
i=[1:L]';
j=1:C;
I=i *ones(1,C); 
J=ones(L,1)*j; 
I=I(:);
J=J(:);

C=size(icoord,2); % number of clusters
head_diameter=head_box(4);
    
for k=2:length(DM)
    R=DM(k).cdata(:,:,1);
    [rr, ii]=sort(255-R(:));
    % points under consideration
    IC=I(ii(1:n));
    JC=J(ii(1:n));
    % sq distance of the points to the previous cluster centers
    for i=1:C
        D(:,i)=(IC-icoord(k-1,i)).^2+(JC-jcoord(k-1,i)).^2;
    end
    % attribute points to the closest cluster centers
    [u, j]=min(D, [], 2);
    % compute distance of hands to head
    DL=sqrt((icoord(k-1,1)-icoord(k-1,2)).^2+(jcoord(k-1,1)-jcoord(k-1,2)).^2);
    DR=sqrt((icoord(k-1,1)-icoord(k-1,3)).^2+(jcoord(k-1,1)-jcoord(k-1,3)).^2);
    if DR<head_diameter || DL<head_diameter
        hand_close_to_head=1;
    else
        hand_close_to_head=0;
    end
    % sort points within each cluster
    for i=1:C
        idx=find(j==i);
        if isempty(idx) || (i==1 && hand_close_to_head)
            icoord(k,i)=icoord(k-1,i);
            jcoord(k,i)=jcoord(k-1,i);
        else
            [d, iii]=sort(D(idx));
            % Compute the candidate new location
            rng=1:min(length(idx), m);
            icoord(k,i)=median(IC(idx(iii(rng))));
            jcoord(k,i)=median(JC(idx(iii(rng)))); 
        end
    end
    if debug
        MDO=overlay(DM(k), icoord(k,:), jcoord(k,:));
        play_movie(MDO);
    end
end

% Add one more coord at the beginning
icoord=[icoord(1,:); icoord];
jcoord=[jcoord(1,:); jcoord];

