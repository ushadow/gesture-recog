classdef TestAHMM < matlab.unittest.TestCase
  
properties
  params;
  hand_size = 4 * 4;
end

methods (TestClassSetup)
  function setUp(self)
    self.params.nG = 4;
    self.params.nS = 4;
    self.params.nF = 2;
    self.params.nX = 2;
    
    self.params.onodes = {'X1'};

    self.params.Gstartprob = [1 0 0 0];
    self.params.Gtransprob = [0 0.45 0.45 0.1
                              0 0.5 0 0.5
                              0 0 0.5 0.5
                              1 0 0 0];
                 
    self.params.Sstartprob = [1 0 0 0
                              0 1 0 0
                              0 0 1 0
                              0 0 0 1];
                       
    self.params.Stransprob = zeros(self.params.nS, self.params.nG, ...
                                   self.params.nS);
    self.params.Stransprob(:, 1, :) = [1 0 0 0 
                                       1 0 0 0 
                                       1 0 0 0 
                                       1 0 0 0];
    self.params.Stransprob(:, 2, :) = [0 1 0 0 
                                       0 1 0 0
                                       0 1 0 0
                                       0 1 0 0];

    self.params.Stransprob(:, 3, :) = [0 0 1 0 
                                       0 0 1 0
                                       0 0 1 0
                                       0 0 1 0];
                                
    self.params.Stransprob(:, 4, :) = [0 0 0 1 
                                       0 0 0 1
                                       0 0 0 1
                                       0 0 0 1];

    self.params.Stermprob = ones(self.params.nG, self.params.nS, 2);
    self.params.Stermprob(1, :, :) = [0 1
                                      0 0
                                      0 0
                                      0 0];
    self.params.Stermprob(2, :, :) = [0 0
                                      0.4 0.6
                                      0 0
                                      0 0];
    self.params.Stermprob(3, :, :) = [0 0
                                      0 0
                                      0 1
                                      0 0];
    self.params.Stermprob(4, :, :) = [0 0
                                      0 0
                                      0 0
                                      0 1];
                             
    self.params.hand = zeros(self.hand_size, self.params.nS);
    for i = 1 : self.params.nS
      self.params.hand(:, i) = repmat(i, self.hand_size, 1);
    end

    self.params.hd_mu = 0;
    self.params.hd_sigma = 1;

    self.params.Xmean = reshape(1 : self.params.nX * self.params.nS, ...
                                [self.params.nX self.params.nS]);
    self.params.Xcov = repmat(eye(self.params.nX) * 0.0001, ...
                              [1, 1, self.params.nS]);
                            
    self.params.resetS = false;
    self.params.Gclamp = false;
    self.params.clampCov = 1;
    self.params.covPrior = 0.01;
  end
end

methods (Test)  

  function testSample(testCase)
    ahmm = createahmm(testCase.params);
    ns = ahmm.node_sizes_slice;
    assertTrue(all(ns == [4 4 2 2]));
    
    T = 10;
    evidence = sample_dbn(ahmm, T);

    G1 = 1; S1 = 2; F1 = 3; X1 = 4; 
    for i = 1 : T
      s = evidence{S1, i};
      hand = evidence{X1, i}{2};
      testCase.verifyEqual(size(hand), [testCase.hand_size, 1]);
      testCase.verifyEqual(size(evidence{X1, i}{1}), [ns(X1), 1]);
      testCase.verifyTrue(all(hand(:) == s));
      testCase.verifyEqual(s, evidence{G1, i});
      checkahmmresult(evidence, G1, F1);
    end
  end
  
  function testInference(testCase)
    det_params = testCase.deterministicParams;
    ahmm = createahmm(det_params);
    engine = smoother_engine(jtree_2TBN_inf_engine(ahmm));

    T = 4;
    ss = length(ahmm.intra);
    testCase.verifyEqual(ss, 4);
    onodes = ahmm.observed;
    testCase.verifyEqual(onodes, 4);

    maxIter = 10;
    for i = 1 : maxIter
      ev = sample_dbn(ahmm, 'length', T);
      %logdebug('TestAHMM', 'ev', ev);
      evidence = cell(ss, T);
      evidence(onodes, :) = ev(onodes, :);

      engine = enter_evidence(engine, evidence);
      hnodes = mysetdiff(1 : ss, onodes);
      map_est = TestAHMM.getMarginals(engine, hnodes, ss, T);
      %logdebug('TestAHMM', 'map_est', map_est);
      for t = 1 : T
        for n = hnodes(:)'
          testCase.verifyEqual(map_est(n, t), ev{n, t});
        end
      end
    end
  end
  
  function testViterbi(testCase)
    detParams = testCase.deterministicParams;
    ahmm = createahmm(detParams);
    engine = smoother_engine(jtree_2TBN_inf_engine(ahmm));

    T = 4;
    ss = length(ahmm.intra);
    onodes = ahmm.observed;

    maxIter = 10;
    for i = 1 : maxIter
      ev = sample_dbn(ahmm, 'length', T);
      %logdebug('TestAHMM', 'ev', ev);
      evidence = cell(ss, T);
      evidence(onodes, :) = ev(onodes, :);

      mpe = find_mpe(engine, evidence);
      hnodes = mysetdiff(1 : ss, onodes);
      mpe = mpe(hnodes, :);
      for t = 1 : T
        for n = hnodes(:)'
          testCase.verifyEqual(mpe{n, t}, ev{n, t});
        end
      end
    end
  end
  
  function testLearning(testCase)
    T = 20;
    max_iter = 10;
    trueParam = testCase.deterministicParams;
    ahmm = createahmm(trueParam);
    ev = sample_dbn(ahmm, 'length', T);
    ss = length(ahmm.intra);
    evidence = cell(1, 1);
    evidence{1} = cell(ss, T);
   
    new_params = testCase.priorParams;
    nodeNames = new_params.names;
    
    onodes = ones(length(new_params.onodes), 1);
    for i = 1 : length(onodes)
      nodeName = new_params.onodes{i};
      onodes(i) = find(strncmp(nodeName, nodeNames, length(nodeName)));
    end

    evidence{1}(onodes, :) = ev(onodes, :);
    
    [new_ahmm, ahmmParam] = createahmm(new_params);
    engine = smoother_engine(jtree_2TBN_inf_engine(new_ahmm));
    [final_ahmm, ~, engine] = learn_params_dbn_em(engine, evidence, ...
        'max_iter', max_iter);
    
    hnodes = mysetdiff(1 : ss, onodes);
    mapEst = mapest(engine, hnodes, T);
    SNDX = hnodes == ahmmParam.S1;
    mapS = mapEst(SNDX(:), :);
    trueS = [ev{ahmmParam.S1, :}];
    testCase.verifyEqual(mapS(:), trueS(:));
    
    learned_Gstartprob = CPD_to_CPT(final_ahmm.CPD{1});
    testCase.verifyEqual(learned_Gstartprob, trueParam.Gstartprob(:));
    learned_Sstartprob = CPD_to_CPT(final_ahmm.CPD{2});
    testCase.verifyEqual(learned_Sstartprob(1, 1), 1);
    learned_Stermprob = CPD_to_CPT(final_ahmm.CPD{3});
    testCase.verifyTrue(all(learned_Stermprob(:, 1) == 0));
    learned_mean = struct(final_ahmm.CPD{4}).mean;
    testCase.verifyEqual(learned_mean(:), trueParam.Xmean(:), 'AbsTol', 0.5);
    learned_GCPT = CPD_to_CPT(final_ahmm.CPD{5});
    learned_GCPT = learned_GCPT(:, 1, :);
    expected = eye(new_params.nG, new_params.nG);
    testCase.verifyEqual(learned_GCPT(:), expected(:));
    learned_Gtransprob = struct(final_ahmm.CPD{5}).transprob;
    assertTrue(all(learned_Gtransprob(:) == trueParam.Gtransprob(:)));
    learned_Stransprob = CPD_to_CPT(final_ahmm.CPD{6});
    testCase.verifyEqual(learned_Stransprob(1, 2, 2), 1, 'AbsTol', 0.01);
    testCase.verifyEqual(learned_Stransprob(2, 3, 3), 1, 'AbsTol', 0.01);
    testCase.verifyEqual(learned_Stransprob(3, 4, 4), 1, 'AbsTol', 0.01);
    testCase.verifyEqual(learned_Stransprob(4, 1, 1), 1, 'AbsTol', 0.01);
  end
  
  function params = deterministicParams(self) %#ok<MANU>
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
  end
  
  function params = priorParams(self) %#ok<MANU>
    params.names = {'G1', 'S1', 'F1', 'X1'};
    % Node size
    params.nG = 4;
    params.nS = 4;
    params.nF = 2;
    params.nX = 2;
    
    params.onodes = {'G1' 'F1' 'X1'};
      
    params.Gstartprob = ones(1, params.nG) / params.nG;
    params.Gtransprob = ones(params.nG, params.nG) / params.nG;
    
    % P_ij = P(S = j | G = i)
    params.Sstartprob = [1 0 0 0
                         0 1 0 0
                         0 0 1 0
                         0 0 0 1];
                       
    params.Stransprob = ones(params.nS, params.nG, params.nS) / params.nS;

    params.Stermprob = ones(params.nG, params.nS, params.nF) / params.nF;

    params.Xmean = [1 3 5 7
                    1 3 5 7];
    params.Xcov = repmat(eye(params.nX), [1, 1, params.nS]);
    params.XcovType = 'diag';
    
    params.resetS = false;
    params.Gclamp = false;
    params.clampCov = 1;
    params.covPrior = 0.01;
  end
end

methods(Static)
  function mapEst = getMarginals(engine, hnodes, ss, T)
  % Computes MAP estimate for hidden nodes.
  % ss: slice size;
    mapEst = zeros(ss, T);
    for t = 1 : T
      for n = hnodes(:)'
        m = marginal_nodes(engine, n, t);
        [~, index] = max(m.T);
        mapEst(n, t) = index;
      end
    end
  end
end
 
end
