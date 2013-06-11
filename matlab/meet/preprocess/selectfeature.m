function X = selectfeature(X, param)

dataType = {'Tr', 'Va', 'Te'};
for i = 1 : length(dataType)
  type = dataType{i};
  if isfield(X, type)
    X.(type) = selectfeature1(X.(type), param.nprincomp);
  elseif strcmp(type, 'Tr')
    X = selectfeature1(X, param.nprincomp);
  end
end
end

function X = selectfeature1(X, nprincomp)
X = cellfun(@(x) x(1 : nprincomp, :), X, 'UniformOutput', false);
end