function batchRes = batchresult(job, data, hyperParam, ntask)
%% BATCHRESULT computes and prints batch results.
%
% batchRes = batchresult(res, dataType, evalName)
% ARGS
% job   - cell array or a parallel job.
% ntask - nbatc x 2 matrix, number of tasks per batch represented as
%         number of models (rows) and number of folds (cols). Only used
%         when job is a cell array.

if isa(job, 'parallel.job.CJSIndependentJob')
  jobRes = arrayfun(@(x) x.OutputArguments{1}, job.Tasks, ...
                    'UniformOutput', false);
  ntask = job.JobData.ntask;
else
  jobRes = job;
end

dataType = {'Tr', 'Va'};
evalName = hyperParam.evalName;

nbatch = size(ntask, 1);
batchRes = containers.Map();
nmodel = ntask(1, 1);

res = cell(1, nbatch);
taskNDX = 0;
for i = 1 : nbatch
  nrow = ntask(i, 1);
  ncol = ntask(i, 2);
  R = cell(nrow, ncol);
  for r = 1 : nrow
    for c = 1 : ncol
      taskNDX = taskNDX + 1;
      if ~isempty(jobRes(taskNDX))
        R{r,c} = jobRes{taskNDX};
      else
        fprintf('empty result for batch %d', i);
      end
    end
  end
  res{i} = R;
end

%% Evaluate results for each model.
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