function [pred, prob, path] = testhmm(~, X, hmm, param)

group = {'Tr', 'Va'};
hmm = hmm.model;
prob = [];

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
for i = 1 : nseqs
  ev = X{i};
  obslik = mixgauss_prob(ev, hmm.mu, hmm.Sigma, hmm.mixmat');
  path{i} = fwdbackonline(hmm.prior, hmm.transmat, obslik, 'lag', 0);
  pred{i} = floor((path{i} - 1) / param.nS) + 1;
end
end