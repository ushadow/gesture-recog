function transmatMask = maketransmask(nHiddenStates, nLabels)
%%
% Transition mask based on Bakis model:
% p       e
% 1 1 1 1 0
% 1 0 1 1 1
% 0 1 0 1 1

% Number of transitions per state.
N = 3;
nStates = nHiddenStates * nLabels;
prior = zeros(1, nStates);
term = zeros(nStates, 1);

for i = 0 : nLabels - 1
  for j = 1 : N - 1
    prior(i * nHiddenStates + j) = 1;
  end
  for j = nHiddenStates : -1 : nHiddenStates - 1
    term(i * nHiddenStates + j) = 1;
  end
end

transmatMask = term * prior;
for i = 0 : nLabels - 1
  for j = 0 : nHiddenStates - 1
    state = i * nHiddenStates + j + 1;
    for k = 0 : N - 1
      nextHiddenState = mod(j + k, nHiddenStates + 1);
      if (nextHiddenState < nHiddenStates)
        transmatMask(state, i * nHiddenStates + nextHiddenState + 1) = 1;
      end
    end
  end
end
end