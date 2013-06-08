function stat = evalclassification(Y, R, evalName, evalFun, verbose)
% Args:
% - R: cell array or struct.
% - evalName: cell array of evaluation names.
% - evalFun: cell array of evaluation functions.

if nargin < 5, verbose = false; end

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
  stat = evalOneFold(Y, R, evalName, evalFun, verbose);
end
end

function stat = evalOneFold(Y, R, evalName, evalFun, verbose)
stat = containers.Map();
datatype = fields(Y);
for i = 1 : length(datatype)
  datatype1 = datatype{i};
  if isfield(Y, datatype1)
    if verbose, logdebug('evalclassification', 'datatype', datatype1); end
    [key, value] = evaluate(Y.(datatype1), R.(datatype1), evalName, ...
                            evalFun, datatype1, verbose);
    for j = 1 : length(key), stat(key{j}) = value{j}; end
  end
end
end

function [resKey, resValue] = evaluate(Ytrue, Ystar, evalName, ...
                                       evalFun, datatype, verbose)
%%
% Args:
% - Ytrue: cell array of sequences.
% - evalFunKey: cell array of evaluation name.
% - evalFun: cell array of evaluation function handle.
nKey = length(evalName);
resKey = cell(1, nKey);
resValue = cell(1, nKey);
for k = 1 : nKey
  sum = 0;
  nseq = size(Ytrue, 2);
  for i = 1 : nseq
    fun = evalFun{k};
    score = fun(Ytrue{i}, Ystar{i}, verbose);
    sum = sum + score;
  end
  resKey{k} = [datatype evalName{k}];
  if verbose
    logdebug('evalclassification', 'sum', sum); 
  end
  resValue{k} = sum / nseq; % computes average
end
end