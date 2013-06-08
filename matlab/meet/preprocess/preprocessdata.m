function data = preprocessdata(data, param)
% Args:
% - X: cell array of sequences of feature vectors.
% - param: a struct with fields:
%   - preprocess: cell arrary of preprocess functions.

preprocess = param.preprocess;
npreprocess = length(preprocess);

for p = 1 : npreprocess
  fun = preprocess{p};
  data = fun(data, param);
end
   
end