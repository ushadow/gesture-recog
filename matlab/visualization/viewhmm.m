function viewhmm(hmm, modelNDX, varargin)
draw_hmm(hmm.transmat{modelNDX}, 'startprob', hmm.prior{modelNDX}, ...
    'endprob', hmm.term{modelNDX}, 'thresh', 1e-2, varargin{:});
end