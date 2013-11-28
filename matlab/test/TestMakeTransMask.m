classdef TestMakeTransMask < matlab.unittest.TestCase
  methods (Test)
    function testMakeTransMaskOne(testCase)
      transmatMask = maketransmask(3, 1);
      expected = [1 1 1
                  1 1 1
                  1 1 1];
      testCase.verifyEqual(transmatMask, expected);
    end
    
    function testMakeTransMaskThree(testCase)
      transmatMask = maketransmask(3, 3);
      expected = [1 1 1 0 0 0 0 0 0
                  1 1 1 1 1 0 1 1 0
                  1 1 1 1 1 0 1 1 0
                  0 0 0 1 1 1 0 0 0
                  1 1 0 1 1 1 1 1 0
                  1 1 0 1 1 1 1 1 0
                  0 0 0 0 0 0 1 1 1
                  1 1 0 1 1 0 1 1 1
                  1 1 0 1 1 0 1 1 1];
      testCase.verifyEqual(transmatMask, expected);
    end
    
    function testMakeTransMaskSixH(testCase)
      transmatMask = maketransmask(6, 2);
      expected = [1 1 1 0 0 0 0 0 0 0 0 0 
                  0 1 1 1 0 0 0 0 0 0 0 0
                  0 0 1 1 1 0 0 0 0 0 0 0
                  0 0 0 1 1 1 0 0 0 0 0 0
                  1 1 0 0 1 1 1 1 0 0 0 0
                  1 1 0 0 0 1 1 1 0 0 0 0
                  0 0 0 0 0 0 1 1 1 0 0 0
                  0 0 0 0 0 0 0 1 1 1 0 0 
                  0 0 0 0 0 0 0 0 1 1 1 0
                  0 0 0 0 0 0 0 0 0 1 1 1
                  1 1 0 0 0 0 1 1 0 0 1 1
                  1 1 0 0 0 0 1 1 0 0 0 1];
      testCase.verifyEqual(transmatMask, expected);
    end
  end
end