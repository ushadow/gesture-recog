function [cPrior, cTransmat, cTerm, cMu, cSigma, cMixmat] = ...
  combinerestmodel(gPrior, gTransmat, gTerm, rTransmat, rTerm, nSMap, ...
  gMu, rMu, gSigma, gMixmat, rSigma, rMixmat)
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

ndx = [1 : 3, stageNDX(3, 1) : stageNDX(3, 1) + 2];
nRToOtherStates = length(ndx);
newRTransmat = rTransmat / (nRToOtherStates + 1);
gTransmat(stageNDX(1, 2) - 2 : stageNDX(1, 2), ...
          stageNDX(3, 1) : stageNDX(3, 1) + 2) = 0.01;
cTransmat = blkdiag(gTransmat, newRTransmat);
cTransmat(end, ndx) = newRTransmat;

cTransmat(1 : end - nSrest, end) =  gToR;
cTransmat = mk_stochastic(cTransmat);

if nargout > 3
  cMu = cat(2, gMu, rMu);
end

if nargout > 4
  cSigma = cat(3, gSigma, rSigma);
  cMixmat = cat(1, gMixmat, rMixmat);
end
end