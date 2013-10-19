function [pred, prob, path] = testhmm(~, X, hmm, param)

group = {'Tr', 'Va'};
hmm = hmm.model;
prob = [];
path = [];

for i = 1 : length(group)
  dataGroup = group{i};
  if isfield(X, dataGroup)
    pred.(dataGroup) = testdatagroup(X.(dataGroup), hmm, param);
  end
end
end

function pred = testdatagroup(X, hmm, param)
nseqs = length(X);
pred = cell(1, nseqs);
for i = 1 : nseqs
  ev = X{i};
  obslik = mixgauss_prob(ev, hmm.mu, hmm.Sigma, hmm.mixmat');
  path = fwdbackonline(hmm.prior, hmm.transmat, obslik, 'lag', 1);
  pred{i} = floor((path - 1) / param.nS) + 1;
end
end