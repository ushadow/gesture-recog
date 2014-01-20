function descriptor = descriptorfeature(data, desRange)
%% DESCRIPTORFEATURE
%
% RETURNS
% descriptor  - a matrix and each column is a feature vector.

mat = cell2mat(data);
descriptor = mat(desRange, :);
end