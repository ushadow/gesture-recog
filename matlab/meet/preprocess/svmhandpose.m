function [X, model] = svmhandpose(Y, X, ~, param)
% ARGS
% Y, X  - structure

model = [];
sampleRate = param.kinectSampleRate;

dirname = param.dir;
file = fullfile(dirname, 'svm_train_hand.txt');
outputsvmhandposedata(file, Y.Tr, X.Tr, sampleRate);

file = fullfile(dirname, 'svm_test_hand.txt');
outputsvmhandposedata(file, Y.Va, X.Va, sampleRate);
end