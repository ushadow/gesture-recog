function exesvmtrain(c, g, w, trainFile)
%%
% ARGS
% w   - vector of weight parameters for label i.

fullPath = GetFullPath('../../matlab-lib/lib');
svmDir = fullfile(fullPath, 'chalearn', 'mfunc', 'libsvm', ...
                  'libsvm-3.17', 'windows');
trainExeFile = fullfile(svmDir, 'svm-train.exe');

weightParam = [];
for i = 1 : length(w)
  weightParam = [weightParam sprintf('-w%d %d ', i, w(i))]; %#ok<AGROW>
end

command = sprintf('%s -c %f -g %f -b 1 %s %s', trainExeFile, c, g, ...
                  weightParam, trainFile);
[~, ~] = system(command);
end