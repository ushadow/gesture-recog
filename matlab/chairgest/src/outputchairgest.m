function outputchairgest(data, result, algo, name, gestureLabel, dtNDX)
% OUTPUTCHAIRGEST outputs chairgest result format.
%
% ARGS
% data - struct with field: param.
% result - cell array of struct with fields: param, prediction, split.
% gestureLabel - cell array of gesture label strings.
% dtNDX  - data type index, 1 = Tr and 2 = Va.

dataType = data.param.dataType;

if nargin < 6
  dtNDX = 2;
end

dt = {'Tr', 'Va'};
dt = dt{dtNDX};

for i = 1 : length(result)  
  result1 = result{i};
  filename = sprintf('%s_%s_%d.txt', algo, dataType, i);
  outputDir = result1.param.dir;
  fid = fopen(fullfile(outputDir, filename), 'w');
  fprintf(fid, '#Algorithm\t%s\t%s\n', algo, name);
  fprintf(fid, '#Data\t%s\t%s\n', dataType, data.param.gtSensorType);

  prediction = result1.prediction.(dt);
  file = data.file(result1.split{dtNDX});
  frame = data.frame(result1.split{dtNDX});
  for j = 1 : length(prediction)
    f1 = file{j};
    p1 = prediction{j}(1, :);
    fr1 = frame{j}; 
    outputonesequence(p1, f1, fr1, gestureLabel, fid);
  end
  fprintf('Result output to %s.\n', filename);
  fclose(fid);
end
end

function outputonesequence(seq, file, frame, gestureLabel, fid)
i = 1;
while i <= length(seq)
  if seq(i) < 11
    start = i;
    gesture = seq(i);
    while i <= length(seq) && seq(i) == gesture
      i = i + 1;
    end
    fprintf(fid, '%s\t%s\t%s\t%s\t%d\t%d\n', file{1}, file{2}, ...
        file{3}, gestureLabel{gesture}, frame(start), frame(i - 1));
  else
    i = i + 1;
  end
end
end