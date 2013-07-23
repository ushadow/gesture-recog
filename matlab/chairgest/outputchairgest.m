function outputchairgest(data, result, algo, name, gestureLabel)
% ARGS
% data - struct with field: param.
% result - struct with field: param.
% gestureLabel - cell array of gesture label strings.

outputDir = result.param.dir;
dataType = data.param.dataType;
filename = [algo '_' dataType '.txt'];
fid = fopen(fullfile(outputDir, filename), 'w');
fprintf(fid, '#Algorithm\t%s\t%s\n', algo, name);
fprintf(fid, '#Data\t%s\t%s\n', dataType, data.param.sensorType);

prediction = result.prediction.Va;
file = data.file(result.split{2});
frame = data.frame(result.split{2});
for j = 1 : length(prediction)
  f1 = file{j};
  p1 = prediction{j}(1, :);
  fr1 = frame{j}; 
  outputonesequence(p1, f1, fr1, gestureLabel, fid);
end
fclose(fid);
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