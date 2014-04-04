function res = separatedata(data, split)
%%
% Separate data into training, validation and testing sets.

dataType = {'Tr', 'Va', 'Te'};
for i = 1 : length(dataType)
  if ~isempty(split{i})
    dataGroup = data(split{i});
    res.(dataType{i}) =  dataGroup(~cellfun('isempty', dataGroup));
  end
end
end