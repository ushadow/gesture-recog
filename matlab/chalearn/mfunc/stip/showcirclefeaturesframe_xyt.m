function showcirclefeaturesframe_xyt(tmoment,features,fcol,linewidth,gcah,textflag)

%
% showcirclefeaturesframe_xyt(tmoment,features,fcol)
%
%   displays spatio-temporal features=[x,y,t,sx,st] corresponding to
%   a moment 'tmoment' drawn by circles with colours fcol=[r,g,b];
%

if nargin<4 linewidth=[]; end
if isempty(linewidth) linewidth=3; end
if nargin<5 gcah=gca; end
if nargin<6 textflag=0; end

set(gcah,'NextPlot','add')
for j=1:size(features,1)
  t=features(j,3);
  st2=features(j,5);
  if st2==0 st2=1; end
  t0=abs(tmoment-t);
  if t0<(sqrt(st2)*2)
  %if t<=tmoment
    x=features(j,2);
    y=features(j,1);
    sx2=features(j,4);
    h=drawellipse(x,y,1/(sqrt(sx2)*2),1/(sqrt(sx2)*2),0,gcah);
    set(h,'LineWidth',4)
    if textflag
      ht=text(x,y,sprintf('%d',j));
      set(ht,'Color',[1 0 0])
    end
    if size(fcol,1)>1
      set(h,'Color',fcol(j,:))
      if textflag set(ht,'Color',fcol(j,:)), end
    else
      set(h,'Color',fcol)
      if textflag set(ht,'Color',fcol), end
    end
    if length(linewidth)>1
      set(h,'LineWidth',linewidth(j));
    else
      set(h,'LineWidth',linewidth);
    end
  end
end





