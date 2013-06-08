function im = blurr( im )
%im = blurr( im )
% Trivial function to blurr the image

% Isabelle Guyon -- isabelle@clopinet.com -- May 2012

if ~isa(im, 'double'), im=double(im); end

for k=1:3
    im(:,:,k)=conv2(im(:,:,k), [1 1 1]/3, 'same');
    im(:,:,k)=conv2(im(:,:,k), [1 1 1]/3', 'same');
end
    
end

