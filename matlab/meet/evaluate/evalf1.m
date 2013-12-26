function [precision, recall, f1] = evalf1(labels, gtLabels)
%%
% ARGS
% labels  - estimated labels
% gtLabels  - groud truth labels

if iscell(labels) && numel(labels)
  if iscell(gtLabels) && numel(gtLabels)
    if numel(gtLabels{1}) ~= size(labels{1}, 2)
      labels = transposeCellArray(labels)';
    end
  end
  labels = cell2mat(labels);
end

if iscell(gtLabels) && numel(gtLabels)
  gtLabels = cell2mat(gtLabels);
end

tp = 0;
fp = 0;
fn = 0;
for i = 1 : length(gtLabels)
  count = quantify(gtLabels(i), labels(i), 1);
  tp = tp + count(1);
  fp = fp + count(2);
  fn = fn + count(4);
end

precision = tp / (tp + fp);
recall = tp / (tp + fn);
f1 = 2 * precision * recall / (precision + recall);
end