function [pred, prob, path, seg] = testhmm(~, X, ~, hmm, param)

group = {'Tr', 'Va'};
hmm = hmm.model;
prob = [];
seg = [];

for i = 1 : length(group)
  dataGroup = group{i};
  if isfield(X, dataGroup)
    [pred.(dataGroup), path.(dataGroup)] = testdatagroup(X.(dataGroup), ...
        hmm, param);
  end
end
end

function [pred, path] = testdatagroup(X, hmm, param)
nseqs = length(X);
pred = cell(1, nseqs);
path = cell(1, nseqs);
map = hmm.map;
for i = 1 : nseqs
  ev = X{i};
  obslik = mixgauss_prob(ev, hmm.mu, hmm.Sigma, hmm.mixmat);
  switch param.inferMethod 
    case 'viterbi'
      path{i} = viterbi_path(hmm.prior, hmm.transmat, obslik, hmm.term);
    case 'fixed-lag-smoothing'
      path{i} = fwdbackonline(hmm.prior, hmm.transmat, obslik, 'lag', ...
          param.L);
  end
  pred{i} = map(path{i});
end
end

