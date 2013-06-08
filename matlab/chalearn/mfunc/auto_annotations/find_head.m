function [ih, jh, kh]=find_head(M, H, k)
%[ih, jh, kh]=find_head(M, H, k)
% Find the head coordinates by convolution of a template in the upper part
% of the image

debug=0;

% Average first image and 2 last ones
R=M(1).cdata(:,:,1)/3+M(k).cdata(:,:,1)/3+M(k-1).cdata(:,:,1)/3;

[L, C]=size(R);
img=double(R(1:L/2,:,:)); % Upper part of the image only
img=img-mean(img(:));


C=conv2(img, H, 'same');

[MC, idx]=max(C);
[mu, jh]=max(MC);
ih=idx(jh);

if debug
    C(ih,jh)=0;
    figure; imagesc(C);
end

kh=R(ih, jh);

return