function h = show_grad( RHO, SINT, COST, h )
%h = show_grad( RHO, SINT, COST, h )
% Show gradients expressed in matrices of norm and sina and cos of angle.

% Isabelle Guyon -- isabelle@clopinet.com -- April 2012
% Inspired by a function of Piotr Dollar.

if nargin<4, h=figure; else figure(h); end

ANGLE=get_angle(SINT,COST,1);
RHO=RHO/max(RHO(:));

% Orientation bar dimensions
w=15;
b=round(.45*w);
e=round(.55*w);
m=(w-1)/2;

% Select the closest bar
s=size(RHO);
M=zeros(w*s);
for r=1:s(1), 
    rs=(1:w)+(r-1)*w;
  for c=1:s(2), 
      cs=(1:w)+(c-1)*w;
      if RHO(r,c)>0.05
          len=round(sqrt(RHO(r,c))*m);
          %len=round(m);
          bar=zeros(w,w); bar(m+1-len:m+1+len,b:e)=1;
          bar(m+len,b-1:e+1)=1;
          M(rs,cs)=imrotate(bar, ANGLE(r,c), 'crop');
      end
  end
end

imdisplay(M, h); 
