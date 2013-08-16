function [Gstartprob, Gtransprob] = initGprob(param)
%% INITGPROB initializes start and transition probabilities for G.
%
% ARGS
% param - AHMM parameters.

nG = param.vocabularySize;
Gstartprob = zeros(1, nG);
Gtransprob = zeros(nG, nG);

Gstartprob(1, 11) = 1;
Gtransprob(1 : 10, 12) = 1;
Gtransprob(11, 1 : 10) = 1 / 10;
Gtransprob(12, 13) = 1;
Gtransprob(13, 1 : 11) = 1 / 11;