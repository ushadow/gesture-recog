classdef TestDenoise < TestCase

properties
  image;
  param;
  expected;
end
  
methods
  function self = TestDenoise(name)
    self = self@TestCase(name);
  end
  
  function setUp(self)
    v = 4.5;
    self.image = [0 0 0 0 0 0 0 
                  0 0 0 0 0 0 0
                  0 0 v v v 0 0  
                  0 0 v 0 v 0 0 
                  0 0 v v v 0 0 
                  0 0 0 0 0 0 0 
                  0 0 0 0 0 0 0];
    self.param.startHandFetNDX = 2;
    self.expected = self.image;
    self.expected(4, 4) = v;
  end
  
  function testOneSeq(self)  
    data = {{[1; self.image(:)]}};
    R = denoise(data, self.param);
    imageWidth = size(self.image, 1);
    denoised = reshape(R{1}{1}(2 : end), imageWidth, imageWidth)';
    assertTrue(all(size(R{1}{1}) == [imageWidth * imageWidth + 1 1]));
    assertTrue(allall(denoised == self.expected));
  end
  
  function testStruct(self)
    data.train = {{[1; self.image(:)] [1; self.image(:)]} ...
                  {[1; self.image(:)] [1; self.image(:)]}};
    data.validate = {{[1; self.image(:)]}};
    R = denoise(data, self.param);
    assertTrue(isstruct(R));
    handFetStartNDX = self.param.startHandFetNDX;
    assertTrue(allall(R.train{2}{2}(handFetStartNDX: end) == ...
                      self.expected(:)));
  end
end
end