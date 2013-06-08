function L = motion(M, parts)
%L = motion(M, parts)
% Compute motion in the parts of the image
% M -- A movie
% parts -- a positive number indicating the number of parts
% Returns 
% L -- a time sequence of features capturing motion in various image parts
% Note: the number of features may be slightly different from "parts"
% because of rounding.

% Isabelle Guyon -- isabelle@clopinet.com -- February 2012

if nargin<2, parts=0; end

len=length(M);
if parts==0
    L=zeros(1,len);
else
    p=sqrt(parts);
    scale=p/size(M(1).cdata(:,:,1),2);
    I=imresize(M(1).cdata(:,:,1), scale);
    L=zeros(prod(size(I)),len);
end
for k=2:length(M)
    D=M(k).cdata(:,:,1)-M(k-1).cdata(:,:,1);
    if parts==0
        n=round(2*size(D,1)/3);
        L(k)=mean(mean(D(n:end,:)));
    else
        ID=imresize(D, scale);
        L(:,k)=ID(:);
    end
end

% Be consistent: features in columns
L=L';

