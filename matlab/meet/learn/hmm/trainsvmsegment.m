function trainsvmsegment(Y, X, restNDX, dirname)
% ARGS
% Y, X  - training data

fid = fopen(fullfile(dirname, 'svm-train-data.txt'), 'w');
% each column is a feature vector
[rest, gesture] = separate(Y, X, restNDX);
nrest = size(rest, 2);
ngesture = size(gesture, 2);
if nrest > ngesture
  index = randperm(nrest);
  rest = rest(:, index(1 : ngesture));
elseif ngesture > nrest
  index = randperm(ngesture);
  gesture = gesture(:, index(1 : nrest));
end

outputsvmdata(fid, rest, 1);
outputsvmdata(fid, gesture, 1);
end

function outputsvmdata(fid, data, label)
d = size(data, 1);
for i = 1 : size(data, 2)
  fprintf(fid, '%d', label);
  for j = 1 : d
    fprintf(fid, ' %d:%f', j, data(j, i));
  end
  fprintf(fid, '\n');
end
end