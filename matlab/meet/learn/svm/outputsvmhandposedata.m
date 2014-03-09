function count = outputsvmhandposedata(fileName, Y, X, gestureType)
%% OUTPUTSVMDATA output data in libsvm format.
%
% ARGS
% Y  - cell array.

Y = cell2mat(Y);
X = cell2mat(X);

% gesture type number is 1-based
gestureTypeNum = ones(size(gestureType));
I = find(strcmp(gestureType, 'S'));
gestureTypeNum(I) = (1 : length(I)) + 1;
type = gestureTypeNum(Y(1, :));

count = hist(type, unique(type));
libsvmwrite(fileName, type, sparse(X'));
end