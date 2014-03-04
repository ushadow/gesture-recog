function viewrecogresult(data, result, dataType, ndx, param)
%% VIEWRECOGNITIONRESULT Visualize gesture recognition validation result.
%
% ARGS
% data  - original data, not separated into training and validation.
% ndx   - index in the data type, e.g. Tr, Va.

figure;
ngestures = data.param.vocabularySize;
gestureLabel = param.gestureLabel;

switch dataType
  case 'Tr'
    splitNdx = 1;
  case 'Va'
    splitNdx = 2;
end

seqNDX = result.split{splitNdx}(ndx);

gt = data.Y{seqNDX}(1, :);
pred = result.prediction.(dataType){ndx}(1, :);
pred(gt == ngestures + 2) = ngestures + 2;
im = [gt; pred];

colormap(bipolar(ngestures));
image(im);

xtick = get(gca, 'XTick');
set(gca, 'XTickLabel', data.frame{seqNDX}(xtick));
xlabel('Time t', 'FontSize', 14);

nrow = size(im, 1);
ytick = 1 : nrow;
line(repmat(xlim', 1, length(ytick) - 1), ...
     repmat((ytick(2 : end) + ytick(1 : end - 1)) / 2, 2, 1), 'Color', 'k');

set(gca, 'YTick', ytick);
set(gca, 'YTickLabel', {'Ground truth', 'Prediction'}, 'FontSize', 14);
yticklabel_rotate;

h = colorbar('NorthOutside');
set(h, 'XTick', 1 : ngestures);
set(h, 'XTickLabel', gestureLabel, 'FontSize', 13);

title(strjoin(data.file{seqNDX}), 'Interpreter', 'none');

if ~isempty(result.path)
  hiddenStates = result.path.(dataType){ndx};
  labels = hiddenstatelabel(param.nS, gestureLabel);
  yTickLabel = {'Hidden states'};
  drawimage(hiddenStates, labels, data.frame{seqNDX}(xtick), yTickLabel);
end
end

function label = hiddenstatelabel(nS, gestureLabel)
totalNStates = sum(nS);
cumSum = cumsum(nS);
label = cell(totalNStates, 1);
j = 1;
for i = 1 : totalNStates
  if i > cumSum(j)
    j = j + 1;
  end
  label{i} = sprintf('%d %s', i, gestureLabel{j});
end
end

function drawimage(data, labels, xTickLabel, yTickLabel)
figure;
nColors = length(labels); 
colormap(bipolar(nColors));
image(data);

set(gca, 'XTickLabel', xTickLabel);
xlabel('Time t', 'FontSize', 14);

nrow = size(data, 1);
ytick = 1 : nrow;
set(gca, 'YTick', ytick); 
set(gca, 'YTickLabel', yTickLabel, 'FontSize', 14);
yticklabel_rotate;
h = colorbar;
set(h, 'YTick', 1 : nColors);
set(h, 'YTickLabel', labels, 'FontSize', 12);
end