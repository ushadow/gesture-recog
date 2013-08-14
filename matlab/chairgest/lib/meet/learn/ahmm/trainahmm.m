function learnedModel = trainahmm(Y, X, param)
%% TRAINAHMM train an AHMM based on training data.
%
% ARGS
% Y, X   - cell array of training data. Each cell is a d x t matrix where
%          d is the feature dimension and t is number of time frames in the
%          sequence.
%
% RETURN
% ahmm   - a structure of trained model and parameters. 

%% Initialize AHMM parameters.
if ~isempty(param.initMeanFilePrefix)
  % Read mean data.
  mean = initmeanfromfile(param.initMeanFilePrefix, size(X{1}, 1), param);
else
  mean = initmean(X, param.nS);
end

[Gstartprob, Gtransprob] = initGprob(param);
param = initahmmparam(param, mean, Gstartprob, Gtransprob); 
[ahmm, ahmmParam] = createahmm(param);

%% Training.
trainData = makedbninputdata(Y, X, ahmmParam);
engine = smoother_engine(jtree_2TBN_inf_engine(ahmm));
finalModel = learn_params_dbn_em(engine, trainData, ...
                'max_iter', param.maxIter, 'thresh', param.thresh);

% Changes hidden bits.
ahmmParam.onodes = [ahmmParam.X1];               
finalModel = sethiddenbit(finalModel, ahmmParam.onodes);
learnedModel.type = 'ahmm';
learnedModel.model = finalModel;
learnedModel.param = ahmmParam;
end

