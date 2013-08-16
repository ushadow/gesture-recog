function [prior, transmat, term] = makepretrans(nS)
if nS == 3
  [prior, transmat, term] = makepreposttrans3(nS);
elseif nS == 4
  [prior, transmat, term] = makepreposttrans4(nS);
else
  [prior, transmat, term] = makepreposttrans6(nS);
end
end

function [prior, transmat, term] = makepreposttrans3(nS)
prior = ones(nS, 1) / nS;
transmat = eye(nS);
term = ones(nS, 1) * 0.5;
end

function [prior, transmat, term] = makepreposttrans4(nS)
prior = zeros(nS, 1);
prior(1 : 3) = 1 / 3;
transmat = zeros(nS, nS);
term = zeros(nS, 1);
for i = 1 : 3
  transmat(i, [i 4]) = 1 / 2;
end
transmat(4, 4) = 1;
term(4) = 0.5;
end

function [prior, transmat, term] = makepreposttrans6(nS)
prior = zeros(nS, 1);
prior(1 : 3) = 1 / 3;
transmat = zeros(nS, nS);
term = zeros(nS, 1);
for i = 1 : 3
  transmat(i, [i i + 3]) = 1 / 2;
  transmat(i + 3, i + 3) = 1;
  term(i + 3) = 0.5;
end
end