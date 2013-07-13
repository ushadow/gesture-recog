function checkdata(data)
%% CHECKDATA checks whether the data is valid. The data is valid if the the 
% gesture label only changes if the termination label is 2.

for j = 1 : numel(data.Y)
  seq = data.Y{j};
  for i = 1 : size(seq, 2) - 1
    if seq(1, i) ~= seq(1, i + 1)
      assert(seq(2, i) == 2, 'Termination label should be 2.');
    else
      assert(seq(2, i) == 1, 'Termination label should be 1.');
    end
  end
  assert(seq(2, end) == 2);
end
disp('Data is valid.');