function savefeature(data, fold, param)
%% SAVEFEATURE saves the standardized training features separating the
%  gestures from the rest poses. Subsamples the gesture features by 2, and 
%  subsamples the rest features by 30.
%
% ARGS
% data    - prepared data.
% fold    - the fold index.
% param   - a struct with field 'dir' which is the director to save the
%           feature.

% Different fold has different standardized feature.
% Only uses training data.

if iscell(data)
  data = data{fold};
end

X = data.X(data.split{1, fold});
Y = data.Y(data.split{1, fold});

Y = cell2mat(Y);
NDX = Y(1, :) ~= 13;
X = cell2mat(X);
Xgesture = X(:, NDX);
Xrest = X(:, ~NDX);
nfeature = size(X, 1);

if isfield(data, 'userId') && ~isempty(data.userId)
  mkdir(param.dir, data.userId);
else
  data.userId = [];
end

filename = sprintf('gesture-%d-%d.csv', nfeature, fold);
csvwrite(fullfile(param.dir, data.userId, filename), ...
         Xgesture(:, 1 : end)');

filename = sprintf('rest-%d-%d.csv', nfeature, fold);
csvwrite(fullfile(param.dir, data.userId, filename), ...
         Xrest(:, 1 : 10 : end)');

filename = sprintf('all-%d-%d.csv', nfeature, fold);
csvwrite(fullfile(param.dir, data.userId, filename), ...
         [Xgesture(:, 1 : end)'; Xrest(:, 1 : 5 : end)']);
end