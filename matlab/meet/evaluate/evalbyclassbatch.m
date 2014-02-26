function aveRes = evalbyclassbatch(data, batchRes, className, model)
%% EVALBYCLASSBATCH evaluate results by class on the total data batch.
% ARGS
% data      - batch data.
% batchRes  - cell array. Eeah cell array is also a cell array of results
%             for different model and fold.

dataType = {'Tr', 'Va'};
fprintf('SetName\t');  

fprintf('\n');

for i = 1 : length(data)
  data1 = data{i};
  batchResMap = evalbyclass(data1.Y, batchRes{i}(model, :), className);
  if i == 1
    aveRes = batchResMap;
  else
    key = keys(batchResMap);
    for j = 1 : length(key)
      aveRes(key{j}) = [aveRes(key{j}) batchResMap(key{j})];
    end
  end
  if ~isfield(data1, 'userId')
    data1.userId = '';
  end
  fprintf('%s\t', data1.userId);
  keys(batchResMap)
  values(batchResMap)
  fprintf('\n');
end

key = keys(aveRes);
for i = 1 : length(key)
  aveRes([key{i} 'BatchMean']) = ignoreNaN(aveRes(key{i}), @mean, 2);
  aveRes([key{i} 'BatchStd']) = ignoreNaN(aveRes(key{i}), @std, 2);
end

fprintf('Average\t');
for d = 1 : length(dataType)
  for v = 1 : length(value)
    valueName = [dataType{d} value{v}];
    if isKey(aveRes, [valueName 'MeanBatchMean'])
      fprintf('%3.2f(%2.2f)\t', 100 * aveRes([valueName 'MeanBatchMean']), ...
              100 * aveRes([valueName 'MeanBatchStd']));
    end
  end
end
fprintf('\n');