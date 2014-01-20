function exesvmtrain(c, g, w, trainFile)
fullPath = GetFullPath('../../matlab-lib/lib');
svmDir = fullfile(fullPath, 'chalearn', 'mfunc', 'libsvm', ...
                  'libsvm-3.17', 'windows');
trainExeFile = fullfile(svmDir, 'svm-train.exe');

weightParam = [];
for i = 1 : length(w)
  weightParam = [weightParam sprintf('-w%d %d ', i - 1, w(i))]; %#ok<AGROW>
end

system(sprintf('%s -c %f -g %f -b 1 %s %s', trainExeFile, c, g, weightParam, ...
               trainFile));
end