function batchRes = batchresult(job, ntask)
%% BATCHRESULT computes and prints batch results.
%
% batchRes = batchresult(res, dataType, evalName)
% ARGS
% job   - cell array or a parallel job.
% ntask - nbatch x 2 matrix, number of tasks per batch represented as
%         number of models (rows) and number of folds (cols). Only used
%         when job is a cell array.
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
batchRes = containers.Map();

for m = 1 : nmodel
  fprintf('SetName\t');  

  for i = 1 : nbatch
    R = res{i}(m, :);
    stat = aggregatecv(R);
    k = keys(stat);
    
    if i == 1
      for r = 1 : 2 : length(k)
        name = k{r};
        fprintf('%s\t', name);
        batchRes([name 'Mean']) = zeros(nbatch, 1);
      end

      fprintf('\n');
    end
  
    fprintf('%s\t', R{1}.param.userId);
      for r = 1 : 2 : length(k)
        resMean = stat(k{r});
        batchMean = batchRes([k{r} 'Mean']);
        fprintf('%.2f\t', resMean);
        batchMean(i) = resMean;
        batchRes([k{r} 'Mean']) = batchMean;
      end

    fprintf('\n');
  end

  fprintf('Average\t');
  k = keys(batchRes);
  for d = 1 : length(k)
    
      batchMean = batchRes(k{d});
      ave = mean(batchMean);
      resStd = std(batchMean);
      fprintf('%.2f(%.2f)\t', ave, resStd);
    
  end
  fprintf('\n');
end 
end