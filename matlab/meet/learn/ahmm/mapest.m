function [mlEst, prob] = mapest(engine, hnode, T)
% ARGS
% hnode   - hidden nodes that we want to estimate the state.
%
% RETURNS
% - mapEst: a matrix.

nhnodes = length(hnode);
mlEst = zeros(nhnodes, T);
prob = cell(nhnodes, T);
for t = 1 : T
  for i = 1 : nhnodes
    m = marginal_nodes(engine, hnode(i), t);
    [~, ndx] = max(m.T);
    mlEst(i, t) = ndx;
    prob{i, T} = m.T;
  end
end