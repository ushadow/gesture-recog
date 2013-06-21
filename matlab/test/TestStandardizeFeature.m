classdef TestStandardizeFeature < matlab.unittest.TestCase
  methods (Test)
    function testStandardizeFeature(testCase)
      X.Tr = {[1 2 3]};
      X.Va = {[4 5 6]};
      standardized = standardizefeature(X);
      [expected, mu, sigma2] = standardize(X.Tr{1});
      testCase.verifyEqual(standardized.Tr{1}, expected);
      testCase.verifyEqual(standardized.Va{1}, standardize(X.Va{1}, mu, ...
                           sigma2));
    end
  end
end