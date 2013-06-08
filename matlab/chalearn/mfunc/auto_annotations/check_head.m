function quality=check_head(M, rect, frame_num)
%quality=check_head(M, rect, frame_num)
%   Check the ratio of depth around the head box and inside

% Isabelle Guyon -- isabelle@clopinet.com -- February 2012

IM=M(frame_num).cdata;
IM(IM==0)=255;

x=round(rect(1));
y=round(rect(2));
w=round(rect(3)/2);
h=round(rect(4)/2);


mu_inside=mean(mean(IM(y:y+h,x:x+w,1)));

mu_left=mean(mean(IM(y+h:y+2*h,1:x,1)));
mu_right=mean(mean(IM(y+h:y+2*h,x+w:size(IM, 2),1)));
mu_outside=0.5*(mu_left+mu_right);

mu_under=mean(mean(IM(y+2*h:size(IM, 1),x:x+2*w,1)));

quality=1-min(abs(mu_inside-mu_under)/abs(mu_outside-mu_under), 1);

end

