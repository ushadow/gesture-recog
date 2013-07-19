function savefeature(data, fold, param)
%% SAVEFEATURE saves the standardized training features separating the
%  gestures from the rest poses. Subsamples the gesture and rest features.
%
% ARGS
% data    - prepared data.
% fold    - the fold index.
% param   - a struct with fields:
%           dir   - the directory to save the feature.
%           gSubsampleFactor
%           rSubsmapleFactor

% Different fold has different standardized feature.
% Only uses training data.

X = data.X(data.split{1, fold});
Y = data.Y(data.split{1, fold});

Y = cell2mat(Y);
NDX = Y(1, :) ~= 13;
X = cell2mat(X);
Xgesture = X(:, NDX);
Xgesture = Xgesture(:, 1 : param.gSampleFactor : end);
Xrest = X(:, ~NDX);
Xrest = Xrest(:, 1 : param.rSampleFactor : end);
nfeature = size(X, 1);

if isfield(data, 'userId') && ~isempty(data.userId)
  mkdir(param.dir, data.userId);
else
  data.userId = [];
end

filename = sprintf('gesture-%d-%d.csv', nfeature, fold);
csvwrite(fullfile(param.dir, data.userId, filename), Xgesture');

filename = sprintf('rest-%d-%d.csv', nfeature, fold);
csvwrite(fullfile(param.dir, data.userId, filename), Xrest');

filename = sprintf('all-%d-%d.csv', nfeature, fold);
csvwrite(fullfile(param.dir, data.userId, filename), [Xgesture'; Xrest']);
end