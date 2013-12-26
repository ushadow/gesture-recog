function filteredLabels = maxlengthlabel(labels, param)
%%
% ARGS
% labels  - cell array of labels.
% nClasses  - total number of class labels, including pre-stroke,
%             post-stroke and rest.

nClasses = param.vocabularySize;
filteredLabels = cellfun(@(x) filterone(x, nClasses), labels, ...
    'UniformOutput', false);

end

function label = filterone(label, nClasses)
nGestures = nClasses - 3;
gestureLen = zeros(1, nGestures);
runs = contiguous(label);
for i = 1 : size(runs, 1)
  gestureLabel = runs{i, 1};
  if gestureLabel <= nGestures
    run = runs{i, 2};
    gestureLen(gestureLabel) = gestureLen(gestureLabel) + ...
                               sum(run(:, 2) - run(:, 1) + 1);
  end
end
[~, gesture] = max(gestureLen);
label(label <= nGestures) = gesture;
end
