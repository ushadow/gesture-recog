classdef TestGaussianProb < matlab.unittest.TestCase
  methods (Test)
    function testGaussianProb(testCase)
      x = [1 2];
      m = [1 2];
      C = diag([1 1]);
      p = gaussian_prob(x', m', C);
      p2 = gaussianprobold(x', m', C);
      expectedP = mvnpdf(x, m, C);
      testCase.verifyEqual(p, p2, 'AbsTol', eps);
      testCase.verifyEqual(p, expectedP, 'AbsTol', eps);
    end
  end
end