function mean = initmeanfromfile(prefix, nfeat, param)
%% INITMEANFROMFILE initializes means from files.
%
% ARGS
% prefix  - a cell array of file prefix.
mean = [];
for i = 1 : 2 : length(prefix)
  filename = sprintf('%s-%d-%d-mean-%d.csv', prefix{i}, nfeat, ...
                     param.fold, prefix{i + 1});
  fullFilePath = fullfile(param.dir, param.userId, filename);
  logdebug('initmeanfromfile', 'fullFilePath', fullFilePath);
  imported = importdata(fullFilePath, ',', 1);
  mean = [mean imported.data]; %#ok<AGROW>
end
