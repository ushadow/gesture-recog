classdef TestReadFeature < matlab.unittest.TestCase
properties (Constant)
  XsensTestFile = 'xsens.txt';
  KinectTestFile = 'kinect.csv';
end
methods (Test)
  function testXsensFeature(testCase)
    data = readfeature(TestReadFeature.XsensTestFile, 'Xsens');
    testCase.verifyEqual(data(1, 1), 23353);
    testCase.verifyEqual(data(end, 1), 23370);
    testCase.verifyEqual(data(1, 3), -0.193517439730764);
    testCase.verifyEqual(size(data, 2), 18 * 4 + 1);
  end
  
  function testKinectFeature(testCase)
    data = readfeature(TestReadFeature.KinectTestFile, 'Kinect');
    testCase.verifyEqual(data(1, 1), 20697);
    testCase.verifyEqual(data(end, 1), 20733);
    testCase.verifyEqual(size(data, 2), 13);
  end
end
end