function viewhmm(hmm, modelNDX, nSMap, varargin)
% viewhmm(hmm, modelNDX, varargin)

transmat = hmm.transmat{modelNDX};
prior = hmm.prior{modelNDX};
term = hmm.term{modelNDX}; 
restNDX = 13;

if iscell(hmm.transmat{modelNDX})
  [prior, transmat, term] = combinehmmparam(prior, transmat, term);
  [prior, transmat, term] = combinerestmodel(prior, transmat, term, ...
      hmm.transmat{restNDX}, hmm.term{restNDX}, nSMap);
end
  
draw_hmm(transmat, 'startprob', prior, 'endprob', term, ...
         'thresh', 1e-3, varargin{:});
end