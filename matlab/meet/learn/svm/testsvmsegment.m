function testsvmsegment(Y, X, restNDX, dirname, modelFile)

testFile = fullfile(dirname, 'svm-test-data');
fid = fopen(testFile, 'w');
% each column is a feature vector
[rest, gesture] = separaterest(Y, X, restNDX);

outputsvmdata(fid, rest, 1);
outputsvmdata(fid, gesture, -1);
fclose(fid);

svmDir = fullfile(pwd, 'chalearn', 'mfunc', 'libsvm', 'code');
testExeFile = fullfile(svmDir, 'svm-predict.exe');
% Use default c = 1, gamma = 1/ nfeatures, use probability (b = 1)
% Do not use shrinking heuristics (h = 0).
resultFile = [testFile '-result'];
system(sprintf('%s -b 1 %s %s %s', testExeFile, testFile, modelFile, ...
       resultFile));
end