function descriptor = descriptorfeature(data, startDescriptorNdx)
%% DESCRIPTORFEATURE
%
% RETURNS
% descriptor  - a matrix and each column is a feature vector.

mat = cell2mat(data);
descriptor = mat(startDescriptorNdx : end, :);
end