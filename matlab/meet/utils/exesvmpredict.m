function result = exesvmpredict(testFile, modelFile, outputFile)
fullPath = GetFullPath('../../matlab-lib/lib');
svmDir = fullfile(fullPath, 'chalearn', 'mfunc', 'libsvm', ...
                  'libsvm-3.17', 'windows');
predictExeFile = fullfile(svmDir, 'svm-predict.exe');

[~, result] = system(sprintf('%s -b 1 %s %s %s', predictExeFile, testFile, modelFile,...
               outputFile));
end