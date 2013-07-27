classdef TestHmm < matlab.unittest.TestCase
methods (Test)
  function testCombineHmmParam(self)
    prior = cell(1, 3);
    transmat = cell(1, 3);
    term = cell(1, 3);
    [prior{1}, transmat{1}, term{1}] = makepreposttrans(3);
    [prior{2}, transmat{2}, term{2}] = makebakistrans(7);
    [prior{3}, transmat{3}, term{3}] = makepreposttrans(3);
    [combinedPrior, combinedTransmat, combinedTerm] = combinehmmparam(prior, ...
        transmat, term);
    self.verifyEqual(sum(combinedPrior), 1);
    self.verifyEqual(combinedPrior, [1 / 3; 1 / 3; 1 / 3; zeros(10, 1)]);
    self.verifyEqual(sum(combinedTransmat, 2), ones(13, 1), 'AbsTol', eps);
    self.verifyEqual(combinedTransmat(1 : 3, 1 : 3), eye(3) * 0.5);
    self.verifyEqual(combinedTransmat(1 : 3, 4 : 5), ones(3, 2) * 0.25);
    self.verifyEqual(combinedTerm, [zeros(10, 1); 0.5; 0.5; 0.5]);
  end
end
end