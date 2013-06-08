function [icoord, jcoord]=track(DM, n, m)
%[icoord, jcoord]=track(DM, n, m)
% Take a movie of differences and track the coordinates
% of the largest difference.
% n     --- number of moving points being considered
% m     --- number of closest pointsto the previous point over which the median is taken
%           m <=n. Increase m to reduce the damping.

[L, C]=size(DM(1).cdata(:,:,1));

if nargin<2, n=round(L*C/50); end
if nargin<2, m=round(max(n/10, 5)); end

if m>n, m=n; end


% Indices of the image coordinates
i=[1:L]';
j=1:C;
I=i *ones(1,C); 
J=ones(L,1)*j; 
I=I(:);
J=J(:);

% Initial moving point
R=DM(1).cdata(:,:,1);
[rr, ii]=sort(255-R(:));
icoord(1)=median(I(ii(1:m)));
jcoord(1)=median(J(ii(1:m)));
    
for k=2:length(DM)
    R=DM(k).cdata(:,:,1);
    [rr, ii]=sort(255-R(:));
    % points under consideration
    IC=I(ii(1:n));
    JC=J(ii(1:n));
    % sq distance of the points to the previous point
    D=(IC-icoord(k-1)).^2+(JC-jcoord(k-1)).^2;
    % sort points by distance
    [d, iii]=sort(D);
    % Compute the new location
    icoord(k)=median(IC(iii(1:m)));
    jcoord(k)=median(JC(iii(1:m))); 
end

% Add one more coord at the beginning
icoord=[icoord(1) icoord];
jcoord=[jcoord(1) jcoord];

