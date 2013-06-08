function MD=overlay(MD, icoord, jcoord, kcoord)
%MD=overlay(MD, icoord, jcoord, kcoord)
% overlay a trajectory on a movie.

% Isabelle Guyon -- isabelle@clopinet.com -- Dec. 2011

if nargin<4
    kcoord=[];
end

m=1;
[L, C]=size(MD(1).cdata(:,:,1));

warning off
c1=[255, 0, 0];
c2=[0, 255, 0];
c3=[0, 0, 255];
for i=1:size(icoord,2)
    for k=1:length(MD)  
        if ~isempty(kcoord)
            m=kcoord(k,i)/50;
        end
        ib=max(1, icoord(k,i)-m); ie=min(icoord(k,i)+m, L);
        jb=max(1, jcoord(k,i)-m); je=min(jcoord(k,i)+m, C);
        MD(k).cdata(ib:ie,jb:je,1)=c1(i);
        MD(k).cdata(ib:ie,jb:je,2)=c2(i);
        MD(k).cdata(ib:ie,jb:je,3)=c3(i);
    end
end
warning on

end

