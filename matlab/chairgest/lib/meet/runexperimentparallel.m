function [nrow, ncol] = runexperimentparallel(split, batchNDX, modelParam, ...
                        jobParam, job, seed)
%% RUNEXPERIMENTPARALLEL runs experiment for one batch of data in parallel.
%
% ARGS
% - modelParam: a cell array of model parameter.

verbose = jobParam.verbose;

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
    createTask(job, @runexperiment, nargout, {params, split(:, fold), fold, batchNDX, seed});
  end
end
if verbose
  t = toc(tid); 
  fprintf('done (%d tasks, %.2f secs)\n', nrow * ncol, t); 
end    
end
