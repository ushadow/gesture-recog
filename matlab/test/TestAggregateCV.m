classdef TestAggregateCV < TestCase
methods
  function self = TestAggregateCV(name)
    self = self@TestCase(name);
  end
  
  function testNaN(self) %#ok<MANU>
    nfold = 3;
    R = cell(1, nfold);
    stat = containers.Map();
    stat('validate-precision') = 1;
    stat('validate-recall') = 0.5;
    R{1} = stat;
    
    stat = containers.Map();
    stat('validate-precision') = NaN;
    stat('validate-recall') = 0.5;
    R{2} = stat;
    
    stat = containers.Map();
    stat('validate-precision') = 0.2;
    stat('validate-recall') = NaN;
    R{3} = stat;
    
    cvstat = aggregatecv(R);
    
    assertTrue(isKey(cvstat, 'validate-precisionMean'));
    result = cvstat('validate-precisionMean');
    assertTrue(result == 0.6);
    result = cvstat('validate-precisionStd');
    assertTrue(abs(result - std([1 0.2])) < 1e-9);
  end
  
  function testTwoDatatypes(self) %#ok<MANU>
    nfold = 3;
    R = cell(1, nfold);
    stat = containers.Map();
    stat('train-error') = 1;
    stat('validate-error') = 0.5;
    R{1} = stat;
    
    stat = containers.Map();
    stat('train-error') = NaN;
    stat('validate-error') = 0.5;
    R{2} = stat;
    
    stat = containers.Map();
    stat('train-error') = 0.2;
    stat('validate-error') = NaN;
    R{3} = stat;
    
    cvstat = aggregatecv(R);
    
    assertTrue(isKey(cvstat, 'train-errorMean'));
    result = cvstat('train-errorMean');
    assertTrue(result == 0.6);
    result = cvstat('train-errorStd');
    assertTrue(abs(result - std([1 0.2])) < 1e-9);
    result = cvstat('validate-errorMean');
    assertTrue(result == 0.5);
    result = cvstat('validate-errorStd');
    assertTrue(result == 0);
  end
end
end