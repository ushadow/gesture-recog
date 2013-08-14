function [standardized, model] = standardizefeature(X, ~, varargin)
% ARGS
% data  - cell array of matrices.
%
% RETURN
% - standardized: if reMat is true, returns a matrix, otherwise returns a 
%                 cell array.

retMat = false;
model = [];
for i = 1 : 2 : length(varargin)
  switch varargin{i}
    case 'retMat'
      retMat = varargin{i + 1};
      logdebug('standardizefeature', 'retMat', retMat);
    case 'model'
      model = varargin{i + 1};
    otherwise
      error(['invalid optional argument' varargin{i}]);
  end
end

if isempty(model)
  if isfield(X, 'Tr')
    train = X.Tr;
  else
    train = X;
  end

  mat = cell2mat(train); % Each column is a feature vector.
  [matTrain, model.mu, model.sigma] = standardize(mat);

  if isfield(X, 'Tr')
    standardized.Tr = mat2cellarray(matTrain, train);
  else
    standardized = matTrain;
  end
end

dataType = {'Va', 'Te'};
for i = 1 : length(dataType)
  type = dataType{i};
  if isfield(X, type)
    mat = cell2mat(X.(type));
    standardized.(type) = standardize(mat, model.mu, model.sigma);
    if ~retMat
      standardized.(type) = mat2cellarray(standardized.(type), X.(type));
    end
  end
end

end