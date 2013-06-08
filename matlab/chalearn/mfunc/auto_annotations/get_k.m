function kcoord=get_k(M, icoord, jcoord)
%kcoord=get_k(M, icoord, jcoord)
% Get the depth information for given i and j coordinates

% Isabelle Guyon -- isabelle@clopinet.com -- Jan 2012

if isnumeric(M)
    m=1;
else
    m=length(M);
end
[p, n]=size(icoord);
if p~=m && m~=1
    error('Wrong coord size');
end

if isnumeric(M)
    mi=mean(M,3);
else
    mi=mean(M(1).cdata, 3);
end
for k=1:p
    if m~=1
        mi=mean(M(k).cdata, 3);
    end
    for i=1:n
        kcoord(k, i)=0.25*(mi(floor(icoord(k,i)), ceil(jcoord(k,i))) + ...
        mi(floor(icoord(k,i)), floor(jcoord(k,i))) + ...
        mi(ceil(icoord(k,i)), floor(jcoord(k,i))) + ...
        mi(ceil(icoord(k,i)), ceil(jcoord(k,i))) );
    end
end