function [ISKINECT, im] = is_depth( im )
%[ISKINECT, im] = is_depth( im )
% Takes an image im and return 1 if it is a depth image
% Also convert im to a 2d double matrix.

% Isabelle Guyon -- isabelle@clopinet.com -- May 2012

ISKINECT=0;
mu=mean(im, 3);
R=double(im(:,:,1));
if max(abs(mu(:)-R(:)))<10
    im=R;
    ISKINECT=1;
end

end

