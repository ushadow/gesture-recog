classdef TestAddFLabel < matlab.unittest.TestCase
  methods (Test)
    function testAlign(testCase)
      Y = [1 1 1 2 2 2 2 3 3 3 3 1 1 1 2 2 2
           1 1 1 1 1 1 1 1 1 2 2 2 2 2 1 1 1];
      Y = addflabel(Y);
      expectedY = [1 1 1 2 2 2 2 3 3 3 3 1 1 1 2 2 2
                  1 1 2 1 1 1 2 1 1 1 2 1 1 2 1 1 2];
      testCase.verifyEqual(Y, expectedY);
    end
  end
end