function X = selectfeature(X, param)

dataType = {'Tr', 'Va', 'Te'};
for i = 1 : length(dataType)
  type = dataType{i};
  if isfield(X, type)
    X.(type) = selectfeature1(X.(type), param.selectedFeature);
  elseif strcmp(type, 'Tr')
    X = selectfeature1(X, param.selectedFeature);
  end
end
end

function X = selectfeature1(X, featureNDX)
X = cellfun(@(x) x(featureNDX, :), X, 'UniformOutput', false);
end