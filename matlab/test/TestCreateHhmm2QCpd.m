classdef TestCreateHhmm2QCpd < matlab.unittest.TestCase

methods (Test)
  function testCreate(self)
    bnet = TestCreateHhmm2QCpd.createBnet;
    node = 5;
    cpdStruct = struct(bnet.CPD{node});
    cpd = createhhmm2qcpd(bnet, node, cpdStruct);
    self.verifyEqual(cpd, bnet.CPD{node});
  end
end

methods (Static)
  function bnet = createBnet
    params.nG = 4;
    params.nS = 4;
    params.nF = 2;
    params.nX = 2;
    
    params.onodes = {'X1'};

    params.Gstartprob = [1 0 0 0];
    params.Gtransprob = [0 1 0 0
                         0 0 1 0
                         0 0 0 1
                         1 0 0 0];

    % 2 x 4 matrix                   
    params.Sstartprob = [1 0 0 0
                         0 1 0 0
                         0 0 1 0
                         0 0 0 1];
                       
    params.Stransprob = zeros(params.nS, params.nG, params.nS);
    params.Stransprob(:, 1, :) = [1 0 0 0 
                                  1 0 0 0 
                                  1 0 0 0 
                                  1 0 0 0];
    params.Stransprob(:, 2, :) = [0 1 0 0 
                                  0 1 0 0
                                  0 1 0 0
                                  0 1 0 0];

    params.Stransprob(:, 3, :) = [0 0 1 0 
                                  0 0 1 0
                                  0 0 1 0
                                  0 0 1 0];
                                
    params.Stransprob(:, 4, :) = [0 0 0 1 
                                  0 0 0 1
                                  0 0 0 1
                                  0 0 0 1];

    params.Stermprob = ones(params.nG, params.nS, 2);
    params.Stermprob(1, :, :) = [0 1
                                 0 0
                                 0 0
                                 0 0];
    params.Stermprob(2, :, :) = [0 0
                                 0 1
                                 0 0
                                 0 0];
    params.Stermprob(3, :, :) = [0 0
                                 0 0
                                 0 1
                                 0 0];
    params.Stermprob(4, :, :) = [0 0
                                 0 0
                                 0 0
                                 0 1];
                             
    params.Xmean = reshape(1 : params.nX * params.nS, ...
                           [params.nX params.nS]);
    params.Xcov = repmat(eye(params.nX) * 0.001, [1, 1, params.nS]);
    params.XcovType = 'diag';
    
    params.resetS = false;
    params.Gclamp = false;
    params.clampCov = 1;
    params.covPrior = 0.01;
    bnet = createahmm(params);
  end
end
end