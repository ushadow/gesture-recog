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

mkdir(param.dir, data.userId);
filename = sprintf('gesture-%d-%d.csv', nfeature, fold);
csvwrite(fullfile(param.dir, data.userId, filename), ...
         Xgesture(:, 1 : 2 : end)');

filename = sprintf('rest-%d-%d.csv', nfeature, fold);
csvwrite(fullfile(param.dir, data.userId, filename), ...
         Xrest(:, 1 : 30 : end)');

end