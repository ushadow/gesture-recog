function standardized = standardizefeature(X, param, varargin)
% ARGS
% - data: cell array of matrices.
%
% Return
% - standardized: if reMat is true, returns a matrix, otherwise returns a 
%                 cell array.
retMat = false;
for i = 1 : 2 : length(varargin)
  switch varargin{i}
    case 'retMat'
      retMat = varargin{i + 1};
      logdebug('standardizefeature', 'retMat', retMat);
    otherwise
      error(['invalid optional argument' varargin{i}]);
  end
end

if isfield(X, 'Tr')
  train = X.Tr;
else
  train = X;
end

mat = cell2mat(train); % Each column is a feature vector.
mat = mat(1 : param.nprincomp, :);
[matTrain, mu, sigma2] = standardize(mat);

if isfield(X, 'Tr')
  standardized.Tr = mat2cellarray(matTrain, train);
else
  standardized = matTrain;
end

dataType = {'Va', 'Te'};
for i = 1 : length(dataType)
  type = dataType{i};
  if isfield(X, type)
    mat = cell2mat(X.(type));
    mat = mat(1 : param.nprincomp, :);
    standardized.(type) = standardize(mat, mu, sigma2);
    if ~retMat
      standardized.(type) = mat2cellarray(standardized.(type), X.(type));
    end
  end
end

end