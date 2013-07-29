function [cPrior, cTransmat, cMu, cSigma, cMixmat, cTerm] = ...
  combinerestmodel(gPrior, gTransmat, gMu, gSigma, gMixmat, gTerm, ...
  rTransmat, rMu, rSigma, rMixmat, rTerm)

nSrest = length(rTerm); % number of hidden state for rest
nSgesture = length(gTerm);

cPrior = cat(1, gPrior, 0);
cMu = cat(2, gMu, rMu);
cSigma = cat(3, gSigma, rSigma);
cMixmat = cat(1, gMixmat, rMixmat);

gTransmat = gTransmat .* (1 - repmat(gTerm, 1, nSgesture)); 
newGTerm = gTerm / 2;
gToR = gTerm - newGTerm;

cTerm = cat(1, newGTerm, rTerm);

cTransmat = blkdiag(gTransmat, rTransmat);
cTransmat(1 : end - nSrest, end) =  gToR;
cTransmat = mk_stochastic(cTransmat);
end