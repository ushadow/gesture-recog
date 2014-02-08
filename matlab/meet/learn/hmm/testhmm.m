function [pred, prob, path, seg, stat] = testhmm(~, X, ~, hmm, param)

group = {'Tr', 'Va'};
hmm = hmm.model;
prob = [];
seg = [];

for i = 1 : length(group)
  dataGroup = group{i};
  if isfield(X, dataGroup)
    [pred.(dataGroup), path.(dataGroup), stat.(dataGroup)] = ...
        testdatagroup(X.(dataGroup), hmm, param);
  end
end
end

function [pred, path, stat] = testdatagroup(X, hmm, param)
nseqs = length(X);
pred = cell(1, nseqs);
path = cell(1, nseqs);
map = hmm.labelMap;
minGamma = 1;
for i = 1 : nseqs
  ev = X{i};
  obslik = mixgauss_prob(ev, hmm.mu, hmm.Sigma, hmm.mixmat);
  switch param.inferMethod 
    case 'viterbi'
      path{i} = viterbi_path(hmm.prior, hmm.transmat, obslik, hmm.term);
    case 'fixed-lag-smoothing'
      [path{i}, stat] = fwdbackonline(hmm.prior, hmm.transmat, obslik, ...
          'lag', param.L);
      minGamma = min(minGamma, stat.minGamma);
  end
  pred{i} = map(path{i});
end
stat.minGamma = minGamma;
end

