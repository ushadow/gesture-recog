classdef TestMakePrePostTransMask < matlab.unittest.TestCase
  methods (Test)
    function test2Labels(testCase)
      nHiddenStates = 3;
      nLabels = 3;
      transMask = makepreposttransmask(nHiddenStates, nLabels);
      expected = [1 1 1 0 0 0 1 1 1
                  1 1 1 0 0 0 1 1 1
                  1 1 1 0 0 0 1 1 1
                  1 1 1 1 1 1 1 1 1
                  1 1 1 1 1 1 1 1 1
                  1 1 1 1 1 1 1 1 1
                  0 0 0 0 0 0 1 1 1
                  0 0 0 0 0 0 1 1 1
                  0 0 0 0 0 0 1 1 1];
      testCase.verifyEqual(transMask, expected); 
    end
  end
end