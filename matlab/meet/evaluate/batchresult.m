function batchRes = batchresult(job, data, hyperParam, ntask)
%% BATCHRESULT computes and prints batch results.
%
% batchRes = batchresult(res, dataType, evalName)
% ARGS
% job   - cell array or a parallel job.
% ntask - nbatch x 2 matrix, number of tasks per batch represented as
%         number of models (rows) and number of folds (cols). Only used
%         when job is a cell array.
class(job)
if ~iscell(job)
  jobRes = arrayfun(@(x) x.OutputArguments{1}, job.Tasks, ...
                    'UniformOutput', false);
  ntask = job.JobData.ntask;
else
  jobRes = job;
end

nbatch = size(ntask, 1);
nmodel = ntask(1, 1);
nfold = ntask(1, 2);
res = groupres(jobRes, nbatch, nmodel, nfold);

%% Evaluate results for each model.
dataType = {'Tr', 'Va'};
evalName = hyperParam.evalName;
batchRes = containers.Map();

for m = 1 : nmodel
  disp(res{1}{m, 1}.param);
  fprintf('SetName\t');  
  for d = 1 : length(dataType)
    for r = 1 : length(evalName)
      name = [dataType{d} evalName{r}];
      fprintf('%s\t', name);
      batchRes([name 'Mean']) = zeros(nbatch, 1);
      batchRes([name 'Std']) = zeros(nbatch, 1);
    end
  end
  fprintf('\n');

  for i = 1 : nbatch
    R = res{i}(m, :);
    stat = aggregatecv(R);
    fprintf('%s\t', R{1}.param.userId);

    for d = 1 : length(dataType)
      for r = 1 : length(evalName)
        resnameMean = [dataType{d} evalName{r} 'Mean'];
        resnameStd = [dataType{d} evalName{r} 'Std'];
        if isKey(stat, resnameMean)
          resMean = stat(resnameMean);
          resStd = stat(resnameStd);
          batchMean = batchRes(resnameMean);
          batchStd = batchRes(resnameStd);
          fprintf('%3.2f(%.2f)\t', 100 * resMean(1), 100 * resStd(1));
          batchMean(i) = resMean(1);
          batchStd(i) = resStd(1);
          batchRes(resnameMean) = batchMean;
          batchRes(resnameStd) = batchStd;
        end
      end
    end
    fprintf('\n');
  end

  fprintf('Average\t');
  for d = 1 : length(dataType)
    for r = 1 : length(evalName)
      batchMean = batchRes([dataType{d} evalName{r} 'Mean']);
      ave = mean(batchMean);
      resStd = std(batchMean);
      fprintf('%3.2f(%.2f)\t', 100 * ave, 100 * resStd);
    end
  end
  fprintf('\n');
  evalbyclassbatch(data, res, 1 : hyperParam.vocabularySize, m);
end 
end