function M = movie2mat( mov )
%M = movie2mat( mov )
% Turns a matlab movie into a matrix
% The data gets flattened as a vector

p=length(mov);
if p==0, M=[]; return; end
m=mov(1).cdata(:);
n=length(m);
M=zeros(p, n);
for k=1:p
    M(k, :)=mov(k).cdata(:);
end

