function [icoord, jcoord]=track(M, n, m)
%[icoord, jcoord]=track(M, n, m)
% Take a movie of differences and track the coordinates
% of the largest difference.
% M    --- Movie
% n     --- number of moving points being considered
% m     --- number of closest pointsto the previous point over which the median is taken
%           m <=n. Increase m to reduce the damping.
% [icoord, jcoord] -- matrices with movie-length lines and up to 3 columns
% for the three main moving points (head and right+left)

% Isabelle Guyon -- isabelle@clopinet.com -- Dec. 2011

debug=0;
debug2=0;

[L, C]=size(M(1).cdata(:,:,1));

if nargin<2, n=round(L*C/100); end
if nargin<3, m=round(max(n/20, 5)); end
if m>n, m=n; end

% Compute consecutive differences 
DM = movie_differences(M);

if debug2, play_movie(DM); end

% Initialize positions
[icoord, jcoord, kcoord, head_box] = ini_head_n_hands(DM, M);

if debug
    MDO=overlay(M(1), icoord, jcoord, kcoord);
    figure; imagesc(MDO.cdata);
    hold on
    rectangle('Position', head_box, 'EdgeColor', 'g');
end

% Find the head template (red channel only)
H=head_template(M, head_box);

% Indices of the image coordinates
i=[1:L]';
j=1:C;
I=i *ones(1,C); 
J=ones(L,1)*j; 
I=I(:);
J=J(:);

CL=size(icoord,2); % number of clusters
head_diameter=head_box(4);
    
figure;
for k=46:47%length(DM)
    % Find the new head position    
    [ih, jh, kh]=find_head(M, H, k);
    if 0% debug
        MDO=overlay(M(k), ih, jh, kh);
        imagesc(MDO.cdata); pause(.2); 
    end

    DR=DM(k).cdata(:,:,1);
    [rr, ii]=sort(255-DR(:));
    % points under consideration
    IC0=I(ii(1:n));
    JC0=J(ii(1:n));
    KC0=get_k(M(k), IC0, JC0);
    % sq distance of the points to the previous cluster centers
    icenter=icoord(k-1,:);
    jcenter=jcoord(k-1,:);
    kcenter=kcoord(k-1,:);
    icenter(1)=ih; % Substitute the head position for its new estimate
    jcenter(1)=jh;
    kcenter(1)=kh;
    for i=1:CL
        D(:,i)=(IC0-icoord(k-1,i)).^2+(JC0-jcoord(k-1,i)).^2+(KC0-kcoord(k-1,i)).^2/10;
        %D(:,i)=(IC0-icoord(k-1,i)).^2+(JC0-jcoord(k-1,i)).^2;
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
    for i=2:CL
        idx=find(j==i);
        if length(idx)<m 
            icoord(k,i)=icoord(k-1,i);
            jcoord(k,i)=jcoord(k-1,i);
            kcoord(k,i)=kcoord(k-1,i);
        else
            [d, iii]=sort(D(idx));
            % Compute the candidate new location
            rng=1:min(length(idx), m);
            IC=IC0(idx(iii(rng)));
            JC=JC0(idx(iii(rng)));
            KC=KC0(idx(iii(rng)));
            icoord(k,i)=median(IC);
            jcoord(k,i)=median(JC); 
            kcoord(k,i)=median(KC);
        end
    end
    
    % Overwrite the head
    icoord(k,1)=ih;
    jcoord(k,1)=jh;
    kcoord(k,1)=kh;
    
    if debug
        MDO=overlay(M(k), icoord(k,:), jcoord(k,:), kcoord(k,:));
        imagesc(MDO.cdata); pause(.5);
    end
end



