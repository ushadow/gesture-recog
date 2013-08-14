function bnet = sethiddenbit(bnet, onodes)
ss = bnet.nnodes_per_slice;
hnodes = mysetdiff(1 : ss, onodes);
bnet.hidden_bitv = zeros(1, 2 * ss);
bnet.hidden_bitv(hnodes) = 1;
bnet.hidden_bitv(hnodes + ss) = 1;
bnet.observed = onodes;
end