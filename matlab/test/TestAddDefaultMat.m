classdef TestAddDefaultMat < matlab.unittest.TestCase
  methods (Test)
    function testAddDefaultMat(testCase)
      lastDimSize = 2;
      res = adddefaultmat({[1, 1]}, 0, 3, lastDimSize);
      expected = zeros(1, 2, lastDimSize);
      expected(:, :, 1) = [1, 1];
      testCase.verifyEqual(res, {expected});
      
      lastDimSize = 2;
      res = adddefaultmat({[1, 1; 2, 2]}, eye(2), 4, lastDimSize);
      expected = repmat(eye(2), [1 1 1 lastDimSize]);
      expected(:, :, 1) = [1, 1; 2, 2];
      testCase.verifyEqual(res, {expected});
      
      lastDimSize = 3;
      res = adddefaultmat({[1, 1; 2, 2]}, 0, 2, lastDimSize);
      expected = zeros(2, lastDimSize);
      expected(:, 1 : 2) = [1, 1; 2, 2];
      testCase.verifyEqual(res, {expected});
    end
  end
end