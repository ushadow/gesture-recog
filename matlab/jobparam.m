function jobParam = jobparam(varargin)
jobParam.verbose = true;
jobParam.destroy = false;
jobParam.parallel = true;
jobParam.wait = false;
jobParam.path = path;

for i = 1 : 2 : length(varargin)
  jobParam.(varargin{i}) = varargin{i + 1};
end
end