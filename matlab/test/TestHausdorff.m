classdef TestHausdorff < TestCase
  methods
    function self = TestHausdorff(name)
      self = self@TestCase(name);
    end
    
    function testOnePoint(self) %#ok<MANU>
      P = [0 1 2];
      Q = [0 1 2];
      hd = hausdorfflikedist(P, Q, 1);
      assertTrue(hd == 0);
    end
    
    function testOnePointDiff(self) %#ok<MANU>
      P = [0 1 2];
      Q = [0 1 1];
      [hd, D] = hausdorfflikedist(P, Q, 1);
      assertTrue(isempty(D));
      assertTrue(hd == 2);
    end
    
    function testTwoPoints(self) %#ok<MANU>
      P = [0 1 2
           0 2 3];
      Q = [0 1 3
           0 1 2];
      hd = hausdorfflikedist(P, Q, 1);
      assertTrue(hd == sqrt(1 / 2) + sqrt(1 / 2));
    end
    
    function testTwoPointsAsy(self) %#ok<MANU>
      P = [0 1 2
           0 2 3];
      Q = [0 2 6
           0 1 2];
      hd = hausdorfflikedist(P, Q, 1);
      assertTrue(hd == sqrt(2 / 2) + sqrt(9 / 2));
    end
  end
end