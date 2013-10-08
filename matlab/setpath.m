function setpath
fullPath = GetFullPath('../../matlab-lib/lib');
addpath(genpath(fullPath), '-end');
addpath(genpath(pwd));
end