function h = imdisplay( im, h, ttl )
%h = imdisplay( im, h, ttl )
% Display grayscale images.

% Isabelle Guyon -- isabelle@clopinet.com -- April 2012

if nargin<3
    ttl=inputname(1);
    ttl(ttl=='_')=' ';
end
if nargin<2, h=figure; else figure(h); end
set(h, 'Name', ttl);

[ISKINECT, im]=is_depth(im);

if isa(im, 'double')
    mini=min(im(:));
    maxi=max(im(:));
    im=(im-mini)./(maxi-mini);
end
imagesc(im); 

if ISKINECT
    colormap(gray);
    colorbar;
end

title(ttl, 'Fontsize', 16, 'FontWeight', 'bold'); 