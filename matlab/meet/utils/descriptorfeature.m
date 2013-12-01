function descriptor = descriptorfeature(data, startDescriptorNdx)
mat = cell2mat(data);
descriptor = mat(startDescriptorNdx : end, :);
end