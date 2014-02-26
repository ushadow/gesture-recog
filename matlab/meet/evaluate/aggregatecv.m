function cvstat = aggregatecv(R)
%% AGGREGATECV aggregates cross-validation results.
%
% ARGS
% R   - cell array.
%
% RETURN
% stat  - cell array.

nfold = size(R, 2);

memo = containers.Map();
for f = 1 : nfold
  memo = computeonefold(R{f}, memo, nfold, f);
end

key = keys(memo);
cvstat = containers.Map();
for i = 1 : length(key)
  resname = key{i};
  quantity = memo(resname);
  fieldNames = fieldnames(quantity{1});
  for j = 1 : length(fieldNames)
    fn = fieldNames{j};
    aggrname = [resname fn 'Mean'];
    q = cellfun(@(x) x.(fn), quantity);
    cvstat(aggrname) = ignoreNaN(q, @mean, 2);
    aggrname = [resname fn 'Std'];
    cvstat(aggrname) = ignoreNaN(q, @std, 2);
  end
end
end

function memo = computeonefold(r, memo, nfold, index)
%
% ARGS
% r   - stats for one fold.

if ~isempty(r)
  if isfield(r, 'stat');
    stat = r.stat;
  else
    stat = r;
  end
  key = keys(stat);
  nkey = length(key);

  for i = 1 : nkey
    resname = key{i};
    resvalue = stat(resname);
    nvar = size(resvalue, 1);

    % Initializes memo if necessary.
    if isKey(memo, resname)
      quantity = memo(resname);
    else
      quantity = cell(nvar, nfold);
    end

    quantity{:, index} = resvalue;
    memo(resname) = quantity;
  end
end
end
