function jobParam = jobparam(varargin)
jobParam.verbose = true;
jobParam.destroy = false;
jobParam.parallel = true;
libPath = genpath('c:/users/yingyin/workspace/matlab-lib/lib');
jobParam.path = [libPath ';' genpath(pwd)];

for i = 1 : 2 : length(varargin)
  jobParam.(varargin{i}) = varargin{i + 1};
end
end