function cvstat = aggregatecv(R)
% AGGREGATECV aggregates cross-validation results.
% Args:
% - R: cell array.
%
% Returns:
% - stat: cell array.
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
  aggrname = [resname 'Mean'];
  cvstat(aggrname) = ignoreNaN(quantity, @mean, 2);

  aggrname = [resname 'Std'];
  cvstat(aggrname) = ignoreNaN(quantity, @std, 2);
end
end

function memo = computeonefold(r, memo, nfold, index)
%
% Args:
% - r: stats for one fold.
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
      quantity = zeros(nvar, nfold);
    end

    quantity(:, index) = resvalue;
    memo(resname) = quantity;
  end
end
end
