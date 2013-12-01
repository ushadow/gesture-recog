function transMask = makepreposttransmask(nHiddenStates, nLabels)
%% MAKEPREPOSTTRANSMASK creates a transition matrix mask that allows 
% transition from all prestroke states to gesture states and from gesture
% states to poststroke states.
%
% ARGS
% nHiddenStates   - number of hidden states per label.
% nLabels         - number of labels.

nStates = nHiddenStates * nLabels;
transMask = zeros(nStates, nStates);
for i = 1 : nLabels
  baseNdx = (i - 1) * nHiddenStates;
  ndx = baseNdx + (1 : nHiddenStates);
  transMask(ndx, ndx) = 1; 
end

postStroke = nLabels;
transMask(:, (postStroke - 1) * nHiddenStates + (1 : nHiddenStates)) = 1;
preStroke = nLabels - 1;
transMask((preStroke - 1) * nHiddenStates + (1 : nHiddenStates), :) = 1;
end