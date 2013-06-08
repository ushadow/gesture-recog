function param = initahmmparam(param, mean, Gstartprob, Gtransprob)
% INITAHMMPARAM initializes AHMM parameters.
%
% Arg
% - param: struct with the following fields
%   -- fold: the current fold.

param.nG = param.vocabularySize;
param.nX = size(mean, 1);
param.nF = 2;

%% Set observed nodes for training.
if param.Fobserved
  param.onodes = {'G1', 'F1', 'X1'};
else
  param.onodes = {'G1', 'X1'};
end

%% Parameters related to G.
if nargin > 2
  param.Gstartprob = Gstartprob;
else
  param.Gstartprob = zeros(1, param.nG);
  param.Gstartprob(1, 1) = 1;
end

if nargin > 3
  param.Gtransprob = Gtransprob;
else
  param.Gtransprob = zeros(param.nG, param.nG);
  delta = 0.05;
  param.Gtransprob(1, 1 : param.nG - 1) = (1 - delta) / (param.nG - 1);
  param.Gtransprob(1, param.nG) = delta;
  param.Gtransprob(2, [1 3 : param.nG]) = delta / (param.nG - 1);
  param.Gtransprob(2, 2) = 1 - delta;
  param.Gtransprob(3 : param.nG, 1) = delta;
  param.Gtransprob(3 : param.nG, 2 : param.nG) = ...
      (1 - delta) / (param.nG - 1);
end

% Parameters related to S. Uniform initialization.
param.Sstartprob = ones(param.nG, param.nS) / param.nS;
param.Stransprob = ones(param.nS, param.nG, param.nS) / param.nS;
param.Stermprob = ones(param.nG, param.nS, param.nF) / param.nF;

param.Xmean = mean;
param.Xcov = repmat(100 * eye(param.nX, param.nX), [1, 1, param.nS]);
end