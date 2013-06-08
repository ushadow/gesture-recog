function preprocessfeaturebyfold(data, fold, param)
% SAVEFEATURE saves the standardized features.
%
% Args
% - data: prepared data.

nfeature = param.nhandFet + param.startHandFetNDX - 1;
split = data.split;
% Different fold has different standardized feature.
% Only use training data.
X = data.X(split{1, fold});

for i = 1 : length(param.preprocess) - 1
  preprocess = param.preprocess{i};
  X = preprocess(X, param);
end
assert(length(X{1}{1}) == nfeature);

processorName = cellfun(@func2str, param.preprocess(1 : end - 1), ...
                        'UniformOutput', false);
processorName = strjoin(processorName, '-');

standardized = standardizefeature(X, 0, 'retMat', true);
assert(size(standardized, 1) == nfeature);
filename = sprintf('%s-%d-%d.csv', processorName, nfeature, fold);
csvwrite(fullfile(param.dir, data.userId, filename), standardized');
end