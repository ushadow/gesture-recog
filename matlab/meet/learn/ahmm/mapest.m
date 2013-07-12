function mapEst = mapest(engine, hnode, T)
% ARGS
% - hnode: hidden node that we want to estimate the state.
% Return
% - mapEst: a matrix.
nhnode = length(hnode);
mapEst = zeros(nhnode, T);
for t = 1 : T
  for i = 1 : nhnode
    m = marginal_nodes(engine, hnode(i), t);
    [~, ndx] = max(m.T);
    mapEst(i, t) = ndx;
  end
end