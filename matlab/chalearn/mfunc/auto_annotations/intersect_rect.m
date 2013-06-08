function surf = intersect_rect( rect1, rect2 )
%surf = intersect_rect( rect1, rect2 )
% Compute the intersection of 2 rectangles.

% Isabelle Guyon -- isabelle@clopinet.com -- February 2012

x1=rect1(1);
y1=rect1(2);
w1=rect1(3);
h1=rect1(4);

x2=rect2(1);
y2=rect2(2);
w2=rect2(3);
h2=rect2(4);

x=max(x1, x2);
y=max(y1, y2);
w=min((x1+w1)-x, (x2+w2)-x);
h=min((y1+h1)-y, (y2+h2)-y);

if h>0 && w>0
    surf=h*w;
else
    surf=0;
end

% normalize the result
surf=surf/sqrt(w1*h1*w2*h2);

end

