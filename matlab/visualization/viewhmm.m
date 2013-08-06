function viewhmm(hmm, modelNDX, nSMap)
% viewhmm(hmm, modelNDX, varargin)

transmat = hmm.transmat{modelNDX};
prior = hmm.prior{modelNDX};
term = hmm.term{modelNDX};
mu = hmm.mu{modelNDX};
restNDX = 13;

if iscell(hmm.transmat{modelNDX})
  [prior, transmat, term, mu] = combinehmmparam(prior, transmat, term, mu);
  [prior, transmat, term, mu] = combinerestmodel(prior, transmat, term, ...
      hmm.transmat{restNDX}, hmm.term{restNDX}, nSMap, mu, hmm.mu{restNDX});
end
  
draw_hmm(transmat, 'startprob', prior, 'endprob', term, ...
         'thresh', 1e-3, 'nodePos', mu(1 : 2, :)' * 500);
end