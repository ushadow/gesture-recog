function count = outputsvmhandposedata(fileName, Y, X, gestureType)
%% OUTPUTSVMDATA output data in libsvm format.
%
% ARGS
% Y  - cell array.

Y = cell2mat(Y);
X = cell2mat(X);

gestureTypeNum = zeros(size(gestureType));
I = find(strcmp(gestureType, 'S'));
gestureTypeNum(I) = 1 : length(I);
type = gestureTypeNum(Y(1, :));

count = hist(type, unique(type));
libsvmwrite(fileName, type, sparse(X'));
end