classdef TestUtil < matlab.unittest.TestCase
methods (Test)
  function testSaveVariable(self)
    TEST_FILE = 'test.mat';
    a.b = 1;
    savevariable(TEST_FILE, 'b', a.b);
    matobj = matfile('test.mat');
    self.verifyEqual(matobj.b, a.b);
    delete(TEST_FILE);
  end
end
end