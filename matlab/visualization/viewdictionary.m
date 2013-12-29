function viewdictionary(D, alpha)
% Visualizes a learned dictionary. 
%
% ARGS
% alpha - cell array 

alpha = cell2mat(alpha);
K = size(D, 2);

[~, maxNdx] = max(alpha);
histFreq = hist(maxNdx, 1 : K);
[~, sortedFreqNdx] = sort(histFreq, 'descend');

viewimage(D(:, sortedFreqNdx(1 : 50)), 1, 1 : 50, 10);