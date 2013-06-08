function runparallel(fun, varParam, constParam, jobParam, nargout)
% Args:
% - varParam: a vector. Varying parameter for the job.
% - constParam: a cell array of constant parameters for the job.

jm = findResource('scheduler', 'type', 'local');
job = createJob(jm);

fprintf('Generate tasks');
tid = tic();
ntask = 0;
for i = 1 : length(varParam)
  createTask(job, fun, nargout, constParam);
  ntask = ntask + 1;
end
t = toc(tid);
fprintf('done (%d tasks, %.2f secs)\n', ntask, t);

pathDep = textscan(jobParam.path, '%s', 'delimiter', ';');
set(job, 'PathDependencies', pathDep{1});
end