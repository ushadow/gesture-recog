function jobParam = jobparam(varargin)
jobParam.verbose = true;
jobParam.destroy = false;
jobParam.parallel = true;
jobParam.wait = false;
absPath = GetFullPath('../../matlab-lib/lib');
libPath = genpath(absPath);
jobParam.path = [libPath ';' genpath(pwd)];

for i = 1 : 2 : length(varargin)
  jobParam.(varargin{i}) = varargin{i + 1};
end
end