function groupedRes = groupres(res, nbatch, nmodel, nfold)
%% GROUPRES groups results into to nmodel rows and nfold colums

groupedRes = cell(1, nbatch);
taskNDX = 0;
for i = 1 : nbatch
  R = cell(nmodel, nfold);
  for r = 1 : nmodel
    for c = 1 : nfold
      taskNDX = taskNDX + 1;
      if ~isempty(res(taskNDX))
        R{r,c} = res{taskNDX};
      else
        fprintf('empty result for batch %d', i);
      end
    end
  end
  groupedRes{i} = R;
end
end