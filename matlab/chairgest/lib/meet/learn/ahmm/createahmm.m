function [model, ahmmParam] = createahmm(param)
% CREATEMODEL creates a graphical AHMM model.
% 
% [model, ahmmParam] = createahmm(param)
% params: a structure of parameters for the model, including parameters for
%         different CPDs.
%   nG, nS, nX: number of states for G, S and X.
%   Gstartprob: nG vector of start prob for G1. 
%   Gtransprob
%   Gclamp: whether to change probability related to G or not.
%   Sstartprob: nG X nS vector of start prob for S1.
%   Stransprob
%   Stermprob
%   resetS: whether to reset S or not.
%   onodes: cell array of name of observed nodes.
%   Xmean, Xcov
%
% Topology of the model:
% G1-->G2 
% |\   ^|\
% | v / | v
% | F1  | F2
% | ^   | ^
% |/    |/
% v     v
% S1-->S2
% |     |
% v     v
% X1    X2

% Topology
names = {'G1', 'S1', 'F1', 'X1'};
ss = length(names); % Number of nodes in one time slice.

intra = zeros(ss);

% Has to be in the topological order.
G1 = 1; S1 = 2; F1 = 3; X1 = 4; 
G2 = G1 + ss; S2 = S1 + ss; F2 = F1; X2 = X1;

intra(G1, S1) = 1;
intra(S1, X1) = 1;
intra(G1, F1) = 1;
intra(S1, F1) = 1;

inter = zeros(ss);
inter(G1, G1) = 1; % Node G1 in slice t - 1 connects to node G1 in slice t.
inter(F1, G1) = 1;
inter(S1, S1) = 1;
if param.resetS
  inter(F1, S1) = 1;
end

nodeSize = double([param.nG param.nS param.nF param.nX]);
dnodes = [G1 S1 F1];

onodes = ones(length(param.onodes), 1);
for i = 1 : length(onodes)
  nodeName = param.onodes{i};
  onodes(i) = find(strncmp(nodeName, names, length(nodeName)));
end

% eclass1(i) is the equivalence class that node i in slice 1 belongs to. 
% eclass2(i) is the equivalence class that node i in slice 2, 3, ..., 
% belongs to.
eclass1 = 1 : ss;
eclass2 = [G2, S2, F2, X2];

ahmmParam.ss = ss;
ahmmParam.G1 = G1;
ahmmParam.S1 = S1;
ahmmParam.F1 = F1;
ahmmParam.X1 = X1;
ahmmParam.onodes = onodes;
ahmmParam.ns = nodeSize;

model = mk_dbn(intra, inter, nodeSize, 'discrete', dnodes, 'observed', ...
                    onodes, 'eclass1', eclass1, 'eclass2', eclass2);

% Set CPD.
% Slice 1.
model.CPD{G1} = tabular_CPD(model, G1, 'CPT', param.Gstartprob, ...
                            'clamped', param.Gclamp);

model.CPD{S1} = tabular_CPD(model, S1, param.Sstartprob);

model.CPD{F1} = tabular_CPD(model, F1, param.Stermprob);

if isfield(param, 'hand')
  model.CPD{X1} = obs_CPD(model, X1, param.hand, param.hd_mu, ...
                         param.hd_sigma, 'mean', param.Xmean, 'cov', ...
                         param.Xcov);
else
  model.CPD{X1} = gaussian_CPD(model, X1, 'mean', param.Xmean, ...
      'cov', param.Xcov, 'cov_type', param.XcovType, ...
      'clamp_cov', param.clampCov, 'cov_prior_weight', param.covPrior);
end

% Slice 2.
model.CPD{G2} = hhmm2Q_CPD(model, G2, 'Fself', [], 'Fbelow', F1, 'Qps', ...
                          [], 'startprob', param.Gstartprob, ...
                          'transprob', param.Gtransprob, ...
                          'clamped', param.Gclamp);
% Tablular CPD are stored as multidimentional arrays where the dimensions
% are arranged in the same order as the nodes. Nodes in the 2nd slice is 
% is after the ndoes in the 1st slice.
if param.resetS
  model.CPD{S2} = hhmmQ_CPD(model, S2, 'Fself', F1, 'Fbelow', [], ...
                            'Qps', G2, 'startprob', param.Sstartprob, ...
                            'transprob', param.Stransprob);
else
  model.CPD{S2} = tabular_CPD(model, S2, param.Stransprob);
end

end