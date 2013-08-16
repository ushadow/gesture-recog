classdef TestReadGtChairgest < matlab.unittest.TestCase

properties (Constant)
  TestFile = 'gtchairgest.txt';
end
  
methods (Test)
  function testLabeling(testCase)
    [gt, vocabSize] = readgtchairgest(TestReadGtChairgest.TestFile, 7281, 9040);
    testCase.verifyEqual(vocabSize, 13);
    testCase.verifyEqual(gt(1, 1 : 2), [7281 11]); 
    testCase.verifyEqual(gt(7331 - 7281 + 1, 1 : 2), [7331 1]);
    testCase.verifyEqual(gt(7441 - 7281 + 1, 1 : 2), [7441 1]);
    testCase.verifyEqual(gt(7442 - 7281 + 1, 1 : 2), [7442 12]);
    testCase.verifyEqual(gt(7532 - 7281 + 1, 1 : 2), [7532 13]);
    testCase.verifyEqual(gt(8111 - 7281 + 1, 1 : 2), [8111 11]);
    testCase.verifyEqual(gt(9040 - 7281 + 1, 1 : 2), [9040 12]);
  end
  
  function testLabelingDifferentStartEnd(testCase)
    startId = 7200;
    endId = 9140;
    gt = readgtchairgest(TestReadGtChairgest.TestFile, startId, endId);
    testCase.verifyEqual(gt(1 : 7330 - startId + 1, 1), (startId : 7330)'); 
    testCase.verifyEqual(gt(1 : 7280 - startId + 1, 2), ones(7280 - startId + 1, 1) * 13); 
    testCase.verifyEqual(gt(7281 - startId + 1, 1 : 2), [7281 11]);
    testCase.verifyEqual(gt(7331 - startId + 1, 1 : 2), [7331 1]);
    testCase.verifyEqual(gt(7441 - startId + 1, 1 : 2), [7441 1]);
    testCase.verifyEqual(gt(7442 - startId + 1, 1 : 2), [7442 12]);
    testCase.verifyEqual(gt(7532 - startId + 1, 1 : 2), [7532 13]);
    testCase.verifyEqual(gt(8111 - startId + 1, 1 : 2), [8111 11]);
    testCase.verifyEqual(gt(9040 - startId + 1, 1 : 2), [9040 12]);
    testCase.verifyEqual(gt((9041 : endId) - startId + 1, 1), (9041 : endId)'); 
    testCase.verifyEqual(gt((9041 : endId) - startId + 1, 2), ones(endId - 9041 + 1, 1) * 13); 
  end
end
end