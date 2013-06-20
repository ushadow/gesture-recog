function savefeature(data, fold, param)
%% SAVEFEATURE saves the standardized training features separating the
%  gestures from the rest poses.
%
% ARGS
% data    - prepared data.
% param   - a struct with field 'dir' which is the director to save the
%           feature.

% Different fold has different standardized feature.
% Only use training data.

X = data.X(data.split{1, fold});
Y = data.Y(data.split{1, fold});

Y = cell2mat(Y);
NDX = Y(1, :) ~= 13;
X = cell2mat(X);
Xgesture = X(:, NDX);
Xrest = X(:, ~NDX);
nfeature = size(X, 1);

X = [Xgesture(:, 1 : 2 : end), Xrest(:, 1 : 10 : end)];

mkdir(param.dir, data.userId);
filename = sprintf('selectfeature-%d-%d.csv', nfeature, fold);
csvwrite(fullfile(param.dir, data.userId, filename), X');
end