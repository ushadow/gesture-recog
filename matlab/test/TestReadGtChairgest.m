classdef TestReadGtChairgest < matlab.unittest.TestCase

properties (Constant)
  TestFile = 'gtchairgest.txt';
end
  
methods (Test)
  function testLabeling(testCase)
    [gt, vocabSize] = readgtchairgest(TestReadGtChairgest.TestFile);
    testCase.verifyEqual(vocabSize, 13);
    testCase.verifyEqual(gt(1, 1 : 2), [7281 11]); 
    testCase.verifyEqual(gt(7331 - 7281 + 1, 1 : 2), [7331 1]);
    testCase.verifyEqual(gt(7441 - 7281 + 1, 1 : 2), [7441 1]);
    testCase.verifyEqual(gt(7442 - 7281 + 1, 1 : 2), [7442 12]);
    testCase.verifyEqual(gt(7532 - 7281 + 1, 1 : 2), [7532 13]);
    testCase.verifyEqual(gt(8111 - 7281 + 1, 1 : 2), [8111 11]);
    testCase.verifyEqual(gt(9040 - 7281 + 1, 1 : 2), [9040 12]);
  end
end
end