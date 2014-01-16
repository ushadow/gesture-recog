function [cPrior, cTransmat, cTerm, cMu, cSigma, cMixmat] = ...
  combinerestmodel(gPrior, gTransmat, gTerm, rTransmat, rTerm, nSMap, ...
  gMu, rMu, gSigma, gMixmat, rSigma, rMixmat)
%% COMBINERESTMODEL combines rest model with the gesture HMM model

nSrest = length(rTerm); % number of hidden state for rest
nSgesture = length(gTerm);
stageNdx = gesturestagendx(nSMap);

cPrior = cat(1, gPrior, 0);

gTransmat = gTransmat .* (1 - repmat(gTerm, 1, nSgesture)); 
newGTerm = gTerm / 2;
gToR = gTerm - newGTerm;
% Allow pre-stroke to terminate.
newGTerm(stageNdx(1, 2) - 2 : stageNdx(1, 2)) = ones(3, 1) * 0.01;
cTerm = cat(1, newGTerm, rTerm);

% Allow pre-stroke to transit to post-stroke.
gTransmat(stageNdx(1, 2) - 2 : stageNdx(1, 2), ...
          stageNdx(3, 1) : stageNdx(3, 1) + 2) = 0.01;
cTransmat = blkdiag(gTransmat, rTransmat);
totalNStates = size(cTransmat, 1);
ndx = [1 : 3, stageNdx(3, 1) : stageNdx(3, 1) + 2, totalNStates];
nRToOtherStates = length(ndx);
cTransmat(end, ndx) = 1 / nRToOtherStates;

% HACK: handle false positive rest positions in a gesture.
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