function [h, p, n]=motion_histograms(V,scale)
%[h, p, n]=motion_histograms(V,scale)
% Extracts motion histograms from a video 
% by reducing the image size by scale factor "scale"
% after computing image differences
% 
% Inputs:
% V              -- A video of nf frames.
% scale          -- Dimension reduction factor.
%
% Returns:
% h         -- Matrix of dimension [nf-1, p*n]
%              the set of histograms, one for each frame-1 in the video
% p         -- Number of lines of the resulting image
% n         -- Number of columns of the resulting image

% Isabelle Guyon -- isabelle@clopinet.com -- October 2011
% Hugo Jair Escalante -- hugojair@inaoep.mx -- April, 2012
% Isabelle Guyon -- isabelle@clopinet.com -- May 2012

if nargin<2, scale=0.05; end



nf=length(V);

% % % Compute image differences indicating motion energy
I1=imresize(V(1).cdata(:,:,1), scale);
[p, n]=size(I1);
dc=p*n;
h=zeros(nf, dc); % First pattern is [0] to get the same number of frames as original data
for i=1:nf-1,
    % % % Compute difference images indicating motion energy
    D=V(i+1).cdata(:,:,1)-V(i).cdata(:,:,1); 
    % % % Severely downsize the image (some kind of histogram)
    DS=imresize(D, scale);
    % % % Rearrange values as a vector
    h(i+1,:)=DS(:);
end


