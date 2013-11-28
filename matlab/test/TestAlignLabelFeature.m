classdef TestAlignLabelFeature < matlab.unittest.TestCase
  methods (Test)
    function testAlign(testCase)
      gt = [2 3 5; 3 8 9];
      feature = [1 2 2 2 2 2 2; 
                 2 2 2 2 2 2 2; 
                 3 3 3 3 3 3 3; 
                 5 5 5 5 5 5 5; 
                 6 5 5 5 5 5 5; 
                 7 5 5 5 5 5 5; 
                 8 8 8 8 8 8 8; 
                 9 9 9 9 9 9 9];
      [Y, X, frame] = alignlabelfeature(gt, feature);
      expectedY = [2 2 3 3; 1 2 1 2];
      expectedFrame = [3 5 8 9];
      expectedX = [3 5 8 9
                   3 5 8 9
                   3 5 8 9
                   3 5 8 9
                   3 5 8 9
                   3 5 8 9];
      testCase.verifyEqual(Y, expectedY);
      testCase.verifyEqual(frame, expectedFrame);
      testCase.verifyEqual(X, expectedX);
    end
    
    function testAlignWithRest(testCase)
       gt = [1 3 5; 2 8 9];
      feature = [1 -1 -1 -1 0 0 0; 
                 2 -1 -1 -1 0 0 0; 
                 3 3 3 3 3 3 3; 
                 5 5 5 5 5 5 5; 
                 6 -1 -1 -1 0 0 0; 
                 7 -1 -1 -1 0 0 0; 
                 8 8 8 8 8 8 8; 
                 9 -1 -1 -1 0 0 0];
      [Y, X, frame] = alignlabelfeature(gt, feature);
      expectedY = [1 1 2 3; 1 2 2 2];
      expectedFrame = [3 5 8 9];
      expectedX = [3 5 8 -1
                   3 5 8 -1
                   3 5 8 -1
                   3 5 8 0
                   3 5 8 0
                   3 5 8 0];
      testCase.verifyEqual(Y, expectedY);
      testCase.verifyEqual(frame, expectedFrame);
      testCase.verifyEqual(X, expectedX);
    end
  end
end