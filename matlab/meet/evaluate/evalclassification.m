function stat = evalclassification(Y, R, param)
% ARGS
% R   - cell array or struct.
% - evalName: cell array of evaluation names.
% - evalFun: cell array of evaluation functions.

evalFun = param.evalFun;
evalName = param.evalName;

if ~iscell(evalFun), evalFun = {evalFun}; end
if ~iscell(evalName), evalName = {evalName}; end

if iscell(R)
  nfold = size(R, 2);
  stat = cell(1, nfold);
  for i = 1 : nfold
    split1 = R{i}.split;
    Ytrue.Tr = Y(split1{1});
    Ytrue.Va = Y(split1{2});
    stat{i} = evalOneFold(Ytrue, R{i}.prediction, evalName, evalFun, ...
                          verbose);
  end
else
  stat = evalOneFold(Y, R, evalName, evalFun, param);
end
end

function stat = evalOneFold(Y, R, evalName, evalFun, param)
stat = containers.Map();
datatype = fields(Y);
for i = 1 : length(datatype)
  datatype1 = datatype{i};
  [key, value] = evaluate(Y.(datatype1), R.(datatype1), evalName, ...
                          evalFun, datatype1, param);
  for j = 1 : length(key), stat(key{j}) = value{j}; end
end
end

function [resKey, resValue] = evaluate(Ytrue, Ystar, evalName, ...
                                       evalFun, datatype, param)
%%
% Args:
% - Ytrue: cell array of sequences.
% - evalFunKey: cell array of evaluation name.
% - evalFun: cell array of evaluation function handle.
nKey = length(evalName);
resKey = cell(1, nKey);
resValue = cell(1, nKey);
for k = 1 : nKey
  fun = evalFun{k};
  resKey{k} = [datatype evalName{k}];
  resValue{k} = fun(Ytrue, Ystar, param);
end
end