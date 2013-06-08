classdef TestImage2Points < TestCase

methods
  function self = TestImage2Points(name)
    self = self@TestCase(name);
  end
  
  function test(self) %#ok<MANU>
    image = [1 2 3 4]';
    points = image2points(image);
    expected = [0 0 1
                1 0 2
                0 1 3
                1 1 4];
    assertTrue(all(points(:) == expected(:)));
  end
  
  function testWithZero(self) %#ok<MANU>
    image = [1 2 3 0]';
    points = image2points(image);
    expected = [0 0 1
                1 0 2
                0 1 3];
    assertTrue(all(points(:) == expected(:)));
  end
end
end
    