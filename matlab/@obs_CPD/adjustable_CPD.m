function p = adjustable_CPD(CPD)
% ADJUSTABLE_CPD Does this CPD have any adjustable params?
% p = adjustable_CPD(CPD)
p = ~CPD.clamped_mean | ~CPD.clamped_cov;
end