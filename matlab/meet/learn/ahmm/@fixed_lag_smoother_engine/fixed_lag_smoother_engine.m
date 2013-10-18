function engine = fixed_lag_smoother_engine(tbn_engine, L)
% SMOOTHER_ENGINE Create an engine which does offline (fixed-interval) smoothing in O(T) space/time
% function engine = smoother_engine(tbn_engine)
%
% tbn_engine is any 2TBN inference engine which supports the following methods:
% fwd, fwd1, back, backT, back1, marginal_nodes and marginal_family.

engine.L = 0;
if ~isempty(L)
  engine.L = L; % Lag
end
engine.tbn_engine = tbn_engine;
engine.b = []; % space to store smoothed messages
engine = class(engine, 'fixed_lag_smoother_engine');
%engine = class(engine, 'smoother_engine', inf_engine(bnet_from_engine(tbn_engine)));

