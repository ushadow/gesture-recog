function trainsvmsegment(Y, X, restNDX, dirname)
% ARGS
% Y, X  - training data

trainFile = fullfile(dirname, 'svm-train-data');
fid = fopen(trainFile, 'w');
% each column is a feature vector
[rest, gesture] = separaterest(Y, X, restNDX);
nrest = size(rest, 2);
ngesture = size(gesture, 2);
if nrest > ngesture
  index = randperm(nrest);
  rest = rest(:, index(1 : ngesture));
elseif ngesture > nrest
  index = randperm(ngesture);
  gesture = gesture(:, index(1 : nrest));
end

outputsvmdata(fid, rest, 1);
outputsvmdata(fid, gesture, -1);
fclose(fid);

svmDir = fullfile(pwd, 'chalearn', 'mfunc', 'libsvm', 'code');
trainExeFile = fullfile(svmDir, 'svm-train.exe');
% Use default c = 1, gamma = 1/ nfeatures, use probability (b = 1)
% Do not use shrinking heuristics (h = 0).
system(sprintf('%s -c 32 -g 0.5 -v 3 %s', trainExeFile, trainFile));

end

