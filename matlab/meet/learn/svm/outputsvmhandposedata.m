function outputsvmhandposedata(fileName, Y, X, sampleRate)
%% OUTPUTSVMDATA output data in libsvm format.
%
% ARGS
% data  - d x n matrix, each colum is a data point.

REMOVE_LEN = 30; % 1s at 30Hz
scaledLen = round(REMOVE_LEN / sampleRate);

Y = cell2mat(Y);
X = cell2mat(X);
[~, ~, gestureType] = gesturelabel();
type = gestureType(Y(1, :));
runs = contiguous(type, 1);
runs = runs{1, 2};
removeMask = zeros(size(type));
for i = 1 : size(runs)
  startNdx = runs(i, 1);
  endNdx = runs(i, 2);
  removeMask(startNdx : min(startNdx + scaledLen, endNdx)) = 1;
  removeMask(max(endNdx - scaledLen, startNdx) : endNdx) = 1;
end

removeNdx = removeMask == 1;
type(removeNdx) = [];
X(:, removeNdx) = [];

n = length(type);
type0Pecentage = round(length(find(type == 0)) * 100 / n);
fprintf('0 : %d, 1 : %d\n', type0Pecentage, 100 - type0Pecentage);
libsvmwrite(fileName, type', sparse(X'));
end