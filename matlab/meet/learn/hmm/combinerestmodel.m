function [cPrior, cTransmat, cMu, cSigma, cMixmat, cTerm] = ...
  combinerestmodel(gPrior, gTransmat, gMu, gSigma, gMixmat, gTerm, ...
  rTransmat, rMu, rSigma, rMixmat, rTerm)
%% COMBINERESTMODEL combines rest model with the gesture HMM model

nSrest = length(rTerm); % number of hidden state for rest
nSgesture = length(gTerm);

cPrior = cat(1, gPrior, 0);
cMu = cat(2, gMu, rMu);
cSigma = cat(3, gSigma, rSigma);
cMixmat = cat(1, gMixmat, rMixmat);


gTransmat = gTransmat .* (1 - repmat(gTerm, 1, nSgesture)); 
newGTerm = gTerm / 2;
gToR = gTerm - newGTerm;
newGTerm(1 : 3) = ones(3, 1) * 0.01;
cTerm = cat(1, newGTerm, rTerm);

newRTransmat = rTransmat / 3;
rToPre = rTransmat / 3;
rToPost = rTransmat / 3;
cTransmat = blkdiag(gTransmat, newRTransmat);
cTransmat(end, 1 : 3) = rToPre * gPrior(1 : 3)';
cTransmat(end, 11 : 13) = rToPost * ones(1, 3) / 3;

cTransmat(1 : end - nSrest, end) =  gToR;
cTransmat = mk_stochastic(cTransmat);
end