classdef TestCombineToOneHmm < matlab.unittest.TestCase

  methods (Test)
    function testTransmat(testCase)
      prior = { [0.5; 0.5; 0; 0] [0.3; 0.7; 0; 0]};
      transmat{1} = [0.5 0.5 0 0; 
                     0 0.5 0.5 0; 
                     0 0 0.5 0.5;
                     0.5 0 0 0.5];
      transmat{2} = [0.3 0.7 0 0; 
                     0 0.3 0.7 0; 
                     0 0 0.3 0.7;
                     0.7 0 0 0.3];
      term = {[0; 0; 0.5; 0.5] [0; 0; 0.2; 0.3]};
      
      mu{1} = repmat(1 : 4, 2, 1);
      mu{2} = mu{1};
      Sigma{1} = repmat([1 0; 0 1], 1, 1, 4);
      Sigma{2} = Sigma{1};
      mixmat{1} = ones(4, 1);
      mixmat{2} = mixmat{1};
      model = combinetoonehmm(prior, transmat, term, mu, Sigma, mixmat);
      testCase.verifyEqual(single([0.5 0.5 0 0 0 0 0 0]), ...
                           model.transmat(1, :));
      testCase.verifyEqual(single([0.125 0.125 0.25 0.25 0.075 0.175 0 0]), ...
                           model.transmat(3, :));
    end
  end
end