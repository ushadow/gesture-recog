function CPD = maximize_params(CPD, ~)

if ~adjustable_CPD(CPD), return; end

if CPD.clamped_mean
  cl_mean = CPD.mean;
else
  cl_mean = [];
end

if CPD.clamped_cov
  cl_cov = CPD.cov;
else
  cl_cov = [];
end

[ss dpsz] = size(CPD.mean);

prior = repmat(CPD.cov_prior_weight * eye(ss, ss), [1 1 dpsz]);

[CPD.mean, CPD.cov] = mixgauss_Mstep(CPD.Wsum, CPD.WY1sum, ... 
    CPD.WY1Y1sum, [], 'cov_type', CPD.cov_type, 'clamped_mean', ...
    cl_mean, 'clamped_cov', cl_cov, 'tied_cov', CPD.tied_cov, ...
    'cov_prior', prior);

CPD.Wsum = CPD.Wsum + (CPD.Wsum == 0);
for i = 1 : dpsz
  CPD.hand(:, i) = CPD.WY2sum(:, i) / CPD.Wsum(i);
end

end

