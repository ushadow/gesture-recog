function data = tomat(data, ~)
%
% Args:
% - data: one batch of data.

type = {'X', 'Y'};

for t = 1 : length(type)
  data1 = data.(type{t});
  for i = 1 : length(data1)
    data1{i} = cell2mat(data1{i});
  end
  data.(type{t}) = data1;
end