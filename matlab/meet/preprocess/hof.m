function H = hof(im1, im2, binSize, norient, clip)
%
% Args:
% - im1, im2: feature images.
% - clip: [.2] value at which to clip histogram bins.

[vx, vy, ~] = Coarse2FineTwoFrames(im1, im2);
M = single(sqrt(vx.^2 + vy.^2));

O = single(mod(atan2(vy, vx), pi)); % [0, pi]
if nargin < 3, binSize = 8; end
if nargin < 4, norient = 9; end
if nargin < 5, clip = 0.2; end

softBin = 1; useHog = 0; 

normRad = binSize;
S = convTri(M, normRad);
normConst = 1e-5;
gradientMex('gradientMagNorm', M, S, normConst); 
H = gradientHist(M, O, binSize, norient, softBin, useHog, clip);
end