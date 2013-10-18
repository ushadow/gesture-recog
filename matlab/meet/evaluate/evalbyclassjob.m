function evalbyclassjob(data, jobRes, className, ntask)
%% EVALBYCLASSJOB Evaluates result from a job.
%
% ARGS
% className - A vector of class names.

if isa(jobRes, 'parallel.job.CJSIndependentJob')
  taskRes = arrayfun(@(x) x.OutputArguments{1}, jobRes.Tasks, ...
                 'UniformOutput', false);
  ntask = jobRes.JobData;
else
  taskRes = jobRes;
end

nbatch = size(ntask, 1);
batchRes = cell(1, nbatch);
taskNDX = 0;
for i = 1 : nbatch
  nrow = ntask(i, 1);
  ncol = ntask(i, 2);
  R = cell(nrow, ncol);
  for r = 1 : nrow
    for c = 1 : ncol
      taskNDX = taskNDX + 1;
      if ~isempty(taskRes(taskNDX))
        R{r,c} = taskRes{taskNDX};
      else
        fprintf('empty result for batch %d', i);
      end
    end
  end
  batchRes{i} = R;
end

nmodel = ntask(1, 1);
for m = 1 : nmodel 
  disp(batchRes{1}{m, 1}.param);
  evalbyclassbatch(data, batchRes, className, m);
end
end