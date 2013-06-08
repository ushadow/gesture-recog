function CPD = reset_ess(CPD)
% RESET_ESS Reset the Expected Sufficient Statistics for the observation 
% CPD.
% CPD = reset_ess(CPD)

CPD.nsamples = 0;
CPD.Wsum = zeros(size(CPD.Wsum));
CPD.WY1sum = zeros(size(CPD.WY1sum));
CPD.WY1Y1sum = zeros(size(CPD.WY1Y1sum));
CPD.WY2sum = zeros(size(CPD.WY2sum));