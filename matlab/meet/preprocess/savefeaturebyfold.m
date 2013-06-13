function savefeaturebyfold(data, fold, param)
% SAVEFEATURE saves the standardized features.
%
% ARGS
% data    - prepared data.
% param   - a struct with field 'dir' which is the director to save the
%           feature.

% Different fold has different standardized feature.
% Only use training data.
X = data.X(data.split{1, fold});

X = cell2mat(X);
nfeature = size(X, 1);
filename = sprintf('selectfeature-%d-%d.csv', nfeature, fold);
csvwrite(fullfile(param.dir, data.userId, filename), X');
end