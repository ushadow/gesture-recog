function [R, prob, path] = testahmm(Y, X, model, param)
%% INFERENCEAHMM performs inference on the AHMM model with the data.
%
% R = inferenceahmm(ahmm, data, predictNode, param)
% ARGS
% - ahmm: the AHMM model.
% - data: cell array of sequences.
% - predictNodes: a vector of nodes to be predicted.
% - param: inference parameters, including 'inferMethod' for inference 
%          method, 'L' for lag time when the infernece method is 
%          'fixed-lag-smoothing'.
%
% RETURNS
% R - inference results for each frame.

path = [];

if strcmp(model.type, 'hmm')
  if param.nM == 1
    [ahmm, ahmmParam] = makeahmmfromhmm(model, param);
  else 
    [ahmm, ahmmParam] = makeahmmmixgaussfromhmm(model, param);
  end
else
  ahmm = model.model;
  ahmmParam = model.param;
end

predictNode = [ahmmParam.G1 ahmmParam.F1 ahmmParam.S1];
trainData = makedbninputdata(Y.Tr, X.Tr, ahmmParam);
[R.Tr, prob.Tr] = inference(ahmm, trainData, predictNode, param);

validateData = makedbninputdata(Y.Va, X.Va, ahmmParam);
[R.Va, prob.Va] = inference(ahmm, validateData, predictNode, param);
end

function [R, prob] = inference(ahmm, data, predictNode, param)
method = param.inferMethod;

jtree = jtree_2TBN_inf_engine(ahmm);

switch method
  case {'fixed-interval-smoothing', 'viterbi'}
    engine = smoother_engine(jtree);
  case 'filtering'
    engine = filter_engine(jtree);
  case {'fixed-lag-smoothing', 'fixed-lag-viterbi'}
    engine = fixed_lag_smoother_engine(jtree, param.L);
  otherwise
    error(['Inference method not implemented: ' method]);
end

nseqs = length(data);
R = cell(1, nseqs);
prob = cell(1, nseqs);
for i = 1 : nseqs
  evidence = data{i};
  switch method
    case {'fixed-interval-smoothing', 'fixed-lag-smoothing'}
      engine = enter_evidence(engine, evidence);
      [R{i}, prob{i}] = mlest(engine, predictNode, length(evidence));
    case 'filtering'
      T = size(evidence, 2);
      nhnode = length(predictNode);
      mapEst = zeros(nhnode, T);
      for t = 1 : T
        for n = 1 : nhnode
          engine = enter_evidence(engine, evidence(:, t), t);
          m = marginal_nodes(engine, predictNode(n), t);
          [~, ndx] = max(m.T);
          mapEst(n, t) = ndx;
        end
      end
      R{i} = mapEst;
    case 'viterbi'
      % Find the most probable explanation (Viterbi).
      mpe = find_mpe(engine, evidence);
      R{i} = cell2mat(mpe(predictNode, :));
    case 'fixed-lag-viterbi'
      mpe = find_mpe(engine, evidence);
      R{i} = cell2mat(mpe(predictNode, :));
    otherwise
      error(['Inference method not implemented: ' method]);
  end
end
end
