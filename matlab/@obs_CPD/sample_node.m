function y = sample_node(CPD, pev)
% SAMPLE_NODE Draws a random sample from P(Xi | x(pi_i), theta_i).
% y = sample_node(CPD, pev)
%
% pev{i} is the value of the i'th parent (if there are any parents)
% y is the sampled value (a 1 x 2 cell array).
y = cell(1, 2);

if isempty(CPD.dps)
  i = 1;
else
  dpvals = cat(1, pev{CPD.dps});
  i = subv2ind(CPD.sizes(CPD.dps), dpvals(:)');
end

y{1} = gsamp(CPD.mean(:, i), CPD.cov(:, :, i), 1);
y{1} = y{1}(:); % makes it a column vector.
y{2} = CPD.hand(:, i);