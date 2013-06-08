function [engine, LL] = enter_evidence(engine, ev)
% ENTER_EVIDENCE Call the offline smoother
% [engine, loglik] = enter_evidence(engine, evidence, ...)
%
% evidence{i,t} = [] if if X(i,t) is hidden, and otherwise contains its observed value (scalar or column vector)
%

L = engine.L;
T = size(ev, 2);
f = cell(1, T);
b = cell(1, T); % b{t}.clpot{c}
ll = zeros(1,T);
[f{1}, ll(1)] = fwd1(engine.tbn_engine, ev(:,1), 1);
for t = 2 : L
  [f{t}, ll(t)] = fwd(engine.tbn_engine, f{t - 1}, ev(:, t), t);
end

for t = L + 1 : T
  [f{t}, ll(t)] = fwd(engine.tbn_engine, f{t - 1}, ev(:, t), t);
  b{t} = backT(engine.tbn_engine, f{t}, t);
  for tau = t - 1 : -1 : t - L
    b{tau} = back(engine.tbn_engine, b{tau + 1}, f{tau}, tau);
  end
end
LL = sum(ll);
engine.b = b;
