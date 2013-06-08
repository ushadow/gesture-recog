function ahmm = trainahmm(Y, X, param)
%% TRAINAHMM train an AHMM based on training data.
%
% ARGS
% Y, X   - cell array of training data.

%% Initialize AHMM parameters.
if param.initFromFile
  % Read mean data.
  preprocessName = preprocessname(param.preprocess);
  filename = sprintf('%s-%d-%d-mean-%d.csv', preprocessName, param.nprincomp, ...
                     param.fold, param.nS);
  fullFilePath = fullfile(param.dir, param.userId, filename);
  logdebug('trainhmm', 'read file', fullFilePath);
  imported = importdata(fullFilePath, ',', 1);
  mean = imported.data;
else
  mean = initmean(X, param.nS);
end

[Gstartprob, Gtransprob] = initGprob(param);
param = initahmmparam(param, mean, Gstartprob, Gtransprob);
param.onodes = {'G1' 'F1' 'X1'}; 
[ahmm, ahmmParam] = createahmm(param);

%% Training.
trainData = makedbninputdata(Y, X, ahmmParam);
engine = smoother_engine(jtree_2TBN_inf_engine(ahmm));
finalModel = learn_params_dbn_em(engine, trainData, ...
                'max_iter', param.maxIter, 'thresh', param.thresh);

ahmmParam.onodes = [ahmmParam.X1];               
finalModel = sethiddenbit(finalModel, ahmmParam.onodes);
ahmm.type = 'ahmm';
ahmm.model = finalModel;
ahmm.param = ahmmParam;
end