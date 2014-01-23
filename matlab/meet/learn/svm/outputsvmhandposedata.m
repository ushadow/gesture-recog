function count = outputsvmhandposedata(fileName, Y, X)
%% OUTPUTSVMDATA output data in libsvm format.
%
% ARGS
% data  - d x n matrix, each colum is a data point.

% gestureType is a row vector.
[~, ~, gestureType] = gesturelabel();

Y = cell2mat(Y);
X = cell2mat(X);
type = gestureType(Y(1, :));

count = hist(type, unique(type));
libsvmwrite(fileName, type', sparse(X'));
end