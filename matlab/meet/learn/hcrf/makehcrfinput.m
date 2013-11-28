function [seqs, labels] = makehcrfinput(Y, X, nclasses)
%
% ARGS
% nclasses  - number of total classes, including pre-stroke, post-stroke
%   and rest

dataByClass = segmentbyclass(Y, X, nclasses, false);
ngestures = nclasses - 1;
labels = {};
seqs = {};
for i = 1 : ngestures
  featureSeqs = dataByClass{i};
  if ~isempty(featureSeqs)
    seqs = [seqs featureSeqs]; %#ok<AGROW>
    newLabels = cellfun(@(x) ones(1, size(x, 2)) * i, featureSeqs, ...
                        'UniformOutput', false); 
    labels = [labels newLabels]; %#ok<AGROW>
  end
end
end