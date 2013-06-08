function param = initahmmparamchairgest(param, mean)
% INITAHMMPARAM initializes AHMM parameters.
%
% Arg
% - param: struct with the following fields
%   -- fold: the current fold.

param.nG = param.vocabularySize;
param.nF = 2;
param.nX = param.nconFet + param.nhandFet;
assert(all(size(mean) == [param.nX param.nS]));

param.ss = 4; % slice size

% Node label
param.G1 = 1; 
param.S1 = 2; 
param.F1 = 3; 
param.X1 = 4;

% Set observed nodes for training.
param.onodes = [param.G1 param.X1];
% Parameters related to G.
param.Gstartprob = zeros(1, param.nG);
param.Gstartprob(11, 1) = 1;

param.Gtransprob = zeros(param.nG, param.nG);
delta = 0.05;
param.Gtransprob(11, 1 : param.nG - 1) = (1 - delta) / (param.nG - 1);
param.Gtransprob(11, param.nG) = delta;
param.Gtransprob(12, 1 : param.nG - 2) = delta / (param.nG - 2);
param.Gtransprob(12, 12 : 13) = (1 - delta) / 2;
param.Gtransprob(13, [11, 13]) = (1 - delta) / 2;
param.Gtransprob(13, [1 : param.nG - 3, 12]) = delta / (param.nG - 2);
param.Gtransprob(1 : param.nG - 3, 12) = 1 - delta;
param.Gtransprob(1 : param.nG - 3, [1 : param.nG - 3, 11, 13]) = ...
    delta / (param.nG - 1);
  
% Parameters related to S. Uniform initialization.
param.Sstartprob = ones(param.nG, param.nS) / param.nS;
param.Stransprob = ones(param.nS, param.nG, param.nS) / param.nS;
param.Stermprob = ones(param.nG, param.nS, param.nF) / param.nF;

param.Xmean = mean;
param.Xcov = repmat(eye(param.nX, param.nX), [1, 1, param.nS]);
param.XcovType = param.covType;
end