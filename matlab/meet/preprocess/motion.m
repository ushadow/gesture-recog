function [X, model] = motion(~, X, param)

model = [];

posNdxRange = [1, param.startDescriptorNdx - 1];
  
if isstruct(X)
  fn = fieldnames(X);
  for i = 1 : length(fn)
    D = X.(fn{i});
    X.(fn{i}) = computemotion(D, posNdxRange);
  end
else
  X = computemotion(X, posNdxRange);
end
end

function data = computemotion(data, posNdxRange)
% ARGS
% data  - cell array

nseq = length(data);
for i = 1 : nseq
  seq = data{i};
  pos = seq(posNdxRange, :);
  vel = zeros(size(pos));
  vel(:, 2 : end) = pos(:, 2 : end) - pos(:, 1 : end - 1);
  data{i} = [pos; vel; seq(posNdxRange(2) + 1 : end, :)];
end
end