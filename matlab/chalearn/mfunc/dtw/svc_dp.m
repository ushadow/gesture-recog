function dp = svc_dp(kernel,u,v,q,gamma,uv,D2mat,coef0)
%dp = svc_dp(kernel,u,v,q,gamma,uv,D2mat,coef0)
% Dot product kernel function
% Parameter: kernel -- Name of the kernel function,
%                       a choice of 'linear', 'polynomial',
%                       'radial', and 'general'.
% Inputs: Can take u and v vectors or matrices.
%         in case of vectors, dp is the dot product.
%         If u=v=X a matrix, returns the Hessian matrix.
% Optional parameters:
%             q -- polynomial degree
%             gamma -- locality parameter
%             D2mat -- matrix computed with the euclid2 kernel
%             coef0 -- kernel bias for libsvm compatibility
% Returns: Dot product or Hessian matrix

% Isabelle Guyon - August 1999 - isabelle@clopinet.com -
if(nargin<3), help svc_dp; error('not enough parameters'); end
if(nargin<4), q=2; end
if(nargin<5), gamma=1; end
if(nargin<6), uv=[]; end
if(nargin<7), D2mat=[]; end
if(nargin<8), coef0=0; end

if strcmp(kernel, 'poly_rbf') & gamma==0,
    if q==1
        kernel='linear_with_bias';
    else
        kernel='poly_with_bias';
    end
end

if(isempty(uv))uv = u*v'; end% the basis of all kernel functions!
switch lower(kernel)
     case 'linear'
        dp = uv;
     case 'linear_with_bias'
        dp = uv+coef0;
     case {'polynomial', 'poly'}
        dp = (uv + 1).^q;
     case 'poly_with_bias'
        dp = (uv + coef0).^q;
     case 'euclid2'
        if(isempty(D2mat)), dp = euclid2(u,v,uv);
        else dp = D2mat; end
     case 'euclid'
        if(isempty(D2mat)), dp = sqrt(euclid2(u,v,uv));
        else dp = sqrt(D2mat); end
     case 'radial2' % gamma=1/sigma^2
        gamma = 0.5*gamma;
        if(isempty(D2mat)), D2mat = euclid2(u,v,uv); end
        dp = exp( - gamma * D2mat);
     case 'radial'
        gamma = sqrt(gamma);
        if(isempty(D2mat)), D2mat = euclid2(u,v,uv); end
        dp = exp( - gamma * sqrt(D2mat));
     case 'general2'
        gamma = 0.5*gamma;
        if(isempty(D2mat)), D2mat = euclid2(u,v,uv); end
        dp = ((uv + 1).^q) .* exp( - gamma * D2mat);
     case 'general'
        gamma = sqrt(gamma);
        if(isempty(D2mat)), D2mat = euclid2(u,v,uv); end
        dp = ((uv + 1).^q) .* exp( - gamma * sqrt(D2mat));
     case 'rbf' % like radial2, but gamma not divided by 2; libsvm cmpatibility
        if(isempty(D2mat)), D2mat = euclid2(u,v,uv); end
        dp = ((uv + coef0).^q) .* exp( - gamma * D2mat);
     case 'poly_rbf' % like general2, but gamma not divided by 2; libsvm cmpatibility
        if(isempty(D2mat)), D2mat = euclid2(u,v,uv); end
        dp = ((uv + coef0).^q) .* exp( - gamma * D2mat);
       
    otherwise 
        disp('Unknown kernel function');
end
     
return
     
function dp = euclid2(u,v,uv)
        uu = sum((u.*u), 2); % (u.*u)*ones(size(u,2),1);
        uu2 = uu(:, ones(size(v,1),1)); clear uu; % repmat(uu,1,size(v,1)); clear uu;
        vv = sum((v.*v), 2); % (v.*v)*ones(size(v,2),1);
        vv2 = vv(:, ones(size(u,1),1)); clear vv; % repmat(vv,1,size(u,1)); clear vv;
        dp = uu2; clear uu2;
        dp = dp - 2 * uv; clear uv;
        dp = dp + vv2'; 
        % dp = uu2 - 2 * uv + vv2';

     