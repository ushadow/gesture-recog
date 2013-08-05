function [cPrior, cTransmat, cTerm, cMu, cSigma, cMixmat] = ...
  combinerestmodel(gPrior, gTransmat, gTerm, rTransmat, rTerm, nSMap, gMu, gSigma, gMixmat, ...
  rMu, rSigma, rMixmat)
%% COMBINERESTMODEL combines rest model with the gesture HMM model

nSrest = length(rTerm); % number of hidden state for rest
nSgesture = length(gTerm);

cPrior = cat(1, gPrior, 0);

stageNDX = gesturestagendx(nSMap);

gTransmat = gTransmat .* (1 - repmat(gTerm, 1, nSgesture)); 
newGTerm = gTerm / 2;
gToR = gTerm - newGTerm;
% Allow pre-stroke to terminate.
newGTerm(stageNDX(1, 2) - 2 : stageNDX(1, 2)) = ones(3, 1) * 0.01;
cTerm = cat(1, newGTerm, rTerm);

newRTransmat = rTransmat / 3;
rToPre = rTransmat / 3;
rToPost = rTransmat / 3;

gTransmat(stageNDX(1, 2) - 2 : stageNDX(1, 2), ...
          stageNDX(3, 1) : stageNDX(3, 1) + 2) = 0.01;
cTransmat = blkdiag(gTransmat, newRTransmat);
cTransmat(end, 1 : 3) = rToPre * gPrior(1 : 3)';
cTransmat(end, stageNDX(3, 1) : stageNDX(3, 1) + 2) = rToPost * ones(1, 3) / 3;

cTransmat(1 : end - nSrest, end) =  gToR;
cTransmat = mk_stochastic(cTransmat);

if nargout > 3
  cMu = cat(2, gMu, rMu);
  cSigma = cat(3, gSigma, rSigma);
  cMixmat = cat(1, gMixmat, rMixmat);
end
end