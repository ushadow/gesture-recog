function [ahmm, ahmmParam] = makeahmmfromhmm(hmm, param)
%% MAKEAHMMFROMHMM creates an AHMM from HMM.
%

if nargin < 2
  error('There must be 2 arguments.');
end

hmm = hmm.model;
param.nG = length(hmm.prior);
param.Xmean = cat(2, hmm.mu{:});
[param.nX, param.nS] = size(param.Xmean);
param.Xcov = cat(3, hmm.Sigma{:});

param.nF = 2;
param.onodes = {'X1'};

param.Sstartprob = zeros(param.nG, param.nS);
param.Stransprob = zeros(param.nS, param.nG, param.nS);
param.Stermprob = zeros(param.nG, param.nS, param.nF);

startNDX = 1; 
for i = 1 : param.nG
  endNDX = startNDX + length(hmm.prior{i}) - 1;
  param.Sstartprob(i, startNDX : endNDX) = hmm.prior{i};
  param.Stransprob(startNDX : endNDX, i, startNDX : endNDX) = hmm.transmat{i};
  param.Stermprob(i, startNDX : endNDX, 2) = hmm.term{i};
  param.Stermprob(i, startNDX : endNDX, 1) = 1 - hmm.term{i};
  
  startNDX = endNDX + 1;
end

[param.Gstartprob, param.Gtransprob] = initGprob(param);
[ahmm, ahmmParam] = createahmm(param);
end