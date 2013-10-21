classdef TestAlignLabelFeature < matlab.unittest.TestCase
  methods (Test)
    function testAlign(testCase)
      gt = [2 3 5; 3 8 9];
      feature = [1 2; 2 4; 3 3; 5 5; 6 6; 7 7; 8 8; 9 9];
      [Y, X, frame] = alignlabelfeature(gt, feature);
      expectedY = [2 2 3 3; 1 2 1 2];
      expectedFrame = [3 5 8 9];
      expectedX = [3 5 8 9];
      testCase.verifyEqual(Y, expectedY);
      testCase.verifyEqual(frame, expectedFrame);
      testCase.verifyEqual(X, expectedX);
    end
  end
end