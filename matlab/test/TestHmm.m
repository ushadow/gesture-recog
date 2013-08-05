classdef TestHmm < matlab.unittest.TestCase
methods (Test)
  function testCombineHmmParam(self)
    nS = [3, 7, 3];
    map = containers.Map(1 : 3, nS);
    d = 1;
    nM = 3;
    prior = cell(1, 3);
    transmat = cell(1, 3);
    term = cell(1, 3);
    mu = cell(1, 3);
    Sigma = cell(1, 3);
    mixmat = cell(1, 3);
    [prior{1}, transmat{1}, term{1}] = makepreposttrans(nS(1));
    [prior{2}, transmat{2}, term{2}] = makebakistrans(nS(2));
    [prior{3}, transmat{3}, term{3}] = makepreposttrans(nS(3));
    
    for i = 1 : length(nS)
      mu{i} = zeros(d, nS(i), nM);
      Sigma{i} = repmat(eye(d), [1 1 nS(i) nM]);
      mixmat{i} = zeros(nS(i), nM);
    end
    
    [gPrior, gTransmat, gMu, gSigma, gMixmat, gTerm] = combinehmmparam(...
        prior, transmat, mu, Sigma, mixmat, term);
    self.verifyEqual(sum(gPrior), 1);
    
    expectedPrior = [1 / 3; 1 / 3; 1 / 3; zeros(10, 1)];
    self.verifyEqual(gPrior, expectedPrior);
    self.verifyEqual(sum(gTransmat, 2), ones(13, 1), 'AbsTol', eps);
    self.verifyEqual(gTransmat(1 : 3, 1 : 3), eye(3) * 0.5);
    self.verifyEqual(gTransmat(1 : 3, 4 : 5), ones(3, 2) * 0.25);
    self.verifyEqual(diag(gTransmat(4 : 8, 4 : 8)), ones(5, 1) / 3, ...
          'AbsTol', eps);
    self.verifyEqual(gTerm, [zeros(10, 1); 0.5; 0.5; 0.5]);
    self.verifyEqual(size(gMu), [d sum(nS) nM]);
    self.verifyEqual(size(gSigma), [d d sum(nS) nM]);
    self.verifyEqual(size(gMixmat), [sum(nS) nM]);
    
    rTransmat = 1;
    rMu = zeros(d, 1, nM);
    rSigma = repmat(eye(d), [1 1 1 nM]);
    rMixmat = [1 0 0];
    rTerm = 0.5;
    
    [cPrior, cTransmat, cMu, cSigma, cMixmat, cTerm] = ...
      combinerestmodel(gPrior, gTransmat, gMu, gSigma, gMixmat, gTerm, ...
      rTransmat, rMu, rSigma, rMixmat, rTerm, map);
    self.verifyEqual(sum(cPrior), 1);
    self.verifyEqual(cPrior, [expectedPrior; 0]); 
    self.verifyEqual(sum(cTransmat, 2), ones(14, 1), 'AbsTol', eps);
    self.verifyEqual(diag(cTransmat(11 : 13, 11 : 13)), ...
        ones(3, 1) * 0.5 / (0.5 + 0.25)); 
    self.verifyEqual(cTerm, [0.01; 0.01; 0.01; zeros(7, 1); 0.25; 0.25; ...
                             0.25; rTerm]);
    self.verifyEqual(size(cMu), [d, sum(nS) + 1, nM]);
    self.verifyEqual(size(cSigma), [d, d sum(nS) + 1, nM]);
    self.verifyEqual(size(cMixmat), [sum(nS) + 1, nM]);
    self.verifyEqual(cTransmat(end, :), [1 / 9, 1 / 9, 1 / 9, ...
                     zeros(1, 7), ones(1, 3) / 9, 1 / 3 ]);
   
  end
  
  function testGestureStageNDX(self)
    map = containers.Map(1 : 3, [6, 7, 6]);
    stageNDX = gesturestagendx(map);
    self.verifyEqual(stageNDX, [1 6; 7 13; 14 19]);
  end
end
end