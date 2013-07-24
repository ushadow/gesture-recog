function [nrow, ncol] = runexperimentparallel(data, batchNDX, modelParam, ...
                        jobParam, job)
%% RUNEXPERIMENTPARALLEL runs experiment for one batch of data in parallel.
%
% ARGS
% - modelParam: a cell array of model parameter.

verbose = jobParam.verbose;

split = data.split;
nrow = numel(modelParam);
ncol = size(split, 2);

nargout = 1; % to be returned from each task 

% Generate tasks
if verbose, fprintf('Generate tasks'); tid = tic(); end

for model = 1 : nrow % for each model (row)
  params = modelParam{model};
  params.jobId = job.ID;
  for fold = 1 : ncol % for each fold (col)
    if verbose, fprintf('.'); end 
    createTask(job, @runexperiment, nargout, {params, fold, batchNDX});
  end
end
if verbose
  t = toc(tid); 
  fprintf('done (%d tasks, %.2f secs)\n', nrow * ncol, t); 
end    
end
