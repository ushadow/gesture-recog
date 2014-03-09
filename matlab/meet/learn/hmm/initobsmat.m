function obsmat = initobsmat(nS, nHandPoseType)
%
% ARGS
% data  - all training data.

obsmat = ones(nS, nHandPoseType) / nHandPoseType;
end