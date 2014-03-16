function [count, label] = outputsvmhandposedata(fileName, Y, X, gestureType)
%% OUTPUTSVMDATA output data in libsvm format.
%
% ARGS
% Y  - cell array.
% gestureType   - possible types are 'D', 'S', 'R', 'O', 'OP'.

Y = cell2mat(Y);
X = cell2mat(X);

type = gestureType(Y(1, :));
I = find(strcmp(type, 'S'));
Y = Y(1, I);
X = X(:, I);

[count, label] = hist(Y, unique(Y));
libsvmwrite(fileName, Y', sparse(X'));
end