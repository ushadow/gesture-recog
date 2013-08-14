function mpe = find_mpe(engine, ev)
% FIND_MPE Find the most probable explanation (Viterbi)
% mpe = enter_evidence(engine, evidence, ...)
%
% evidence{i,t} = [] if if X(i,t) is hidden, and otherwise contains its observed value (scalar or column vector)
%

mpe = cell(size(ev));
engine.tbn_engine = set_fields(engine.tbn_engine, 'maximize', 1);

L = engine.L;
T = size(ev, 2);
f = cell(1,T);
b = cell(1,T); % b{t}.clpot{c}
ll = zeros(1,T);
[f{1}, ll(1)] = fwd1(engine.tbn_engine, ev(:, 1), 1);
for t = 2 : min(L, T)
  [f{t}, ll(t)] = fwd(engine.tbn_engine, f{t - 1}, ev(:, t), t);
end

if T==1
  [b{1}, mpe(:,1)] = backT_mpe(engine.tbn_engine, f{1}, ev(:, 1), 1);
else
  for t = L + 1 : T
    [f{t}, ll(t)] = fwd(engine.tbn_engine, f{t - 1}, ev(:, t), t);
    [b{t}, mpe(:, t)] = backT_mpe(engine.tbn_engine, f{t}, ev(:, t - 1 : t), t);
    for tau = t - 1 : -1 : t - L
      if tau == 1
        [b{tau}, mpe(:, tau)] = back1_mpe(engine.tbn_engine, b{tau + 1}, ...
            f{tau}, ev(:, 1), tau);
      else
        [b{tau}, mpe(:, tau)] = back_mpe(engine.tbn_engine, b{tau + 1}, ...
            f{tau}, ev(:, tau - 1 : tau), tau);
      end
    end
  end
end
engine.b = b;
  


