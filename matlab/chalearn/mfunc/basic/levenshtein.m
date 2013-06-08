function q = levenshtein(s1,s2)
%q = levenstein(s1,s2)
% Code from
% http://en.wikibooks.org/wiki/Algorithm_Implementation/Strings/Levenshtein_distance
% with a small boundary condition error corrected.

n1 = numel(s1);
n2 = numel(s2);
d = toeplitz(1 : n1 + 1, 1 : n2 + 1) - 1;
for j = 1:n2
  for i = 1:n1
    d(i+1,j+1) = min(min(d(i, j + 1), d(i + 1, j)) + 1, ...
                     d(i, j) + ne(s1(i), s2(j)));
  end
end
q = d(end);