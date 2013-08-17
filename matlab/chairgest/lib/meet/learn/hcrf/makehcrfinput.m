function [seqs, labels] = makehcrfinput(Y, X, nclasses)
%
% ARGS
% nclasses  - number of total classes, including pre-stroke, post-stroke
%   and rest

% Combines pre- and post stages.
dataByClass = segmentbyclass(Y, X, nclasses, true);
ngestures = nclasses - 3;
labels = {};
seqs = {};
for i = 1 : ngestures
  featureSeqs = dataByClass{i};
  seqs = [seqs featureSeqs]; %#ok<AGROW>
  newLabels = cellfun(@(x) ones(1, size(x, 2)) * i, featuresSeqs, ...
                      'UniformOutput', false); 
  labels = [labels newLabels]; %#ok<AGROW>
end
end