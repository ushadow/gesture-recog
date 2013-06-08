function [RHO, SINT, COST] = approx_grad( M , scale, debug )
%[RHO, SINT, COST] = approx_grad( M , scale, debug )
% Compute the norm RHO and the cosine and sine SINT and COST of the
% gradients at evey pixel in image M in an approximate way.
% M -- image (gray scale)
% scale -- factor by which to rescale the image (rescaling a the end, not
% faster)
% debug -- 1 to show images

% Isabelle Guyon -- isabelle@clopinet.com -- April 2012

if nargin<2, scale=1; end
if nargin<3, debug=0; end

if ~isa(M, 'double'), M=double(M); end

[p, n, d]=size(M);
% Vertical differences
SINT=M(3:p, 1:n, :)-M(1:p-2, 1:n, :); SINT=[SINT(1,:, :); SINT; SINT(end,:, :)];
% Horizontal differences
COST=M(1:p, 3:n, :)-M(1:p, 1:n-2, :); COST=[COST(:,1, :), COST, COST(:,end, :)];
% Norm
RHO=sqrt(SINT.^2+COST.^2);

if nargout>1
    NORMA=RHO;
    NORMA(RHO==0)=eps;
    % Normalization (we take the perpendicular to be consistent with other work)
    SINT=SINT./NORMA;
    COST=COST./NORMA;
end

if scale<1 && scale>0
    miniM=imresize(M, scale); % better to reduce first for the norm
    RHO=approx_grad(miniM);
    if nargout>1 % better the compute the direction before reducing
        SINT=imresize(SINT, scale);
        COST=imresize(COST, scale);
    end
end

if debug>0
    imdisplay(RHO);
    imdisplay(SINT);
    imdisplay(COST);
end

end

