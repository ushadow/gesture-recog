function res = separatedata(data, split)
dataType = {'Tr', 'Va', 'Te'};
for i = 1 : length(dataType)
  if ~isempty(split{i})
    res.(dataType{i}) = data(split{i});
  end
end
end