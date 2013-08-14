function r = cross_correlation_coeff( Ytrue, Ystar )
% [r] = cross_correlation_coeff(Ytrue, Ystar)
%   Computes cross correlation coefficient, a performance metric for AVEC
%
% Input:
%   - Ytrue : n-by-1 vector ground truth label
%   - Ystar : n-by-1 vector predicted label
%
% Output:
%   - r     : cross correlation coefficient, c(i,j)/sqrt(c(i,i)c(j,j))

    assert( size(Ytrue,1)==size(Ystar,1) );
    R = corrcoef(Ytrue,Ystar);
    r = R(1,2);
end

