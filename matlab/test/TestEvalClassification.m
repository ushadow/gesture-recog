classdef TestEvalClassification < TestCase
 
methods
  function self = TestEvalClassification(name)
    self = self@TestCase(name);
  end
  
  function testEvalOneFold(self) %#ok<MANU>
    Y.train = {{1 2; 3 4}};
    Y.validate = {{5 6; 7 8}};
    R.train = {{1 2; 3 4}};
    R.validate = {{5 6; 7 8}};
    stat = evalclassification(Y, R, {'Error'}, {@errorperframe});
    train = stat('trainError');
    validate = stat('validateError');
    assertTrue(length(train) == 1);
    assertTrue(all(train == 0));
    assertTrue(all(validate == 0));
  end
  
  function testEvalOneFoldMoreSeqs(self) %#ok<MANU>
    Y.train = {{1 2; 3 4} {5 6; 7 8}};
    Y.validate = {{5 6; 7 8}};
    R.train = {{1 2; 3 4} {5 8; 7 9}};
    R.validate = {{5 6; 7 8}};
    stat = evalclassification(Y, R, 'Error', @errorperframe);
    train = stat('trainError');
    validate = stat('validateError');
    assertTrue(train == 0.25);
    assertTrue(all(validate == 0));
  end
  
  function testTwoEvalFun(self) %#ok<MANU>
    Y.train = {{1 2} {5 6}};
    Y.validate = {{5 6 6}};
    R.train = {{1 2} {5 8}};
    R.validate = {{5 5 6}};
    stat = evalclassification(Y, R, {'Error' 'Leven'}, ...
                              {@errorperframe @levenscore});
    train = stat('trainError');
    assertTrue(train == 0.25);
    
    trainLeven = stat('trainLeven');
    assertTrue(trainLeven == 0.25);
    
    assertTrue(stat('validateError') == 1/ 3);
    assertTrue(stat('validateLeven') == 0);
  end
end
end