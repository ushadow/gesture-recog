function runjob(fun, nargout, argument, jobParam)
%
% ARGS
% argument  - cell array of arguments to the fun.

jm = findResource('scheduler', 'type', 'local');
job = createJob(jm);
createTask(job, fun, nargout, argument);
set(job, 'PathDependencies', strread(jobParam.path, '%s', 'delimiter', ';'));
submit(job);
end