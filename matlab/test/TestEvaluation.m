classdef TestEvaluation < matlab.unittest.TestCase
methods (Test)
  function testErrorPerFrame(self)
    Ytrue = [1 1 0 0 1];
    Ystar = Ytrue == 1;
    error = errorperframe(Ytrue, Ystar);
    self.verifyEqual(error, 0);
  end
end
end