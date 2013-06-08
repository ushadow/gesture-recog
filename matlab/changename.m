function R = changename(R)

name = {'train', 'validate', 'test'};
target = {'Tr', 'Va', 'Te'};

for j = 1 : length(R)
  pred = R{j}.prediction;
  for i = 1 : length(name)
    if isfield(pred, name{i})
      pred.(target{i}) = pred.(name{i});
      pred = rmfield(pred, name{i});
    end
  end

  R{j}.prediction = pred;
end