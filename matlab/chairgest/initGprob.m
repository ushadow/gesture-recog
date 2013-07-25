function [Gstartprob, Gtransprob] = initGprob(param)
%% INITGPROB initializes start and transition probabilities for G.
%
% ARGS
% param - AHMM parameters.

nG = param.vocabularySize;
Gstartprob = zeros(1, nG);
Gtransprob = zeros(nG, nG);
% for i = 1 : numel(Ytrain)
%   ev = Ytrain{i};
%   Gstartprob(ev{1, 1}) = Gstartprob(ev{1, 1}) + 1;
%   for j = 2 : size(ev, 2)
%     Gtransprob(ev{1, j - 1}, ev{1, j}) = ...
%         Gtransprob(ev{1, j - 1}, ev{1, j}) + 1;
%   end
% end

% Gstartprob = normalise(Gstartprob, 2);
% Gtransprob = normalise(Gtransprob, 2);

Gstartprob(1, 11) = 1;
Gtransprob(1 : 10, 12) = 1;
Gtransprob(11, 1 : 10) = 1 / 10;
Gtransprob(12, 13) = 1;
Gtransprob(13, 1 : 11) = 1 / 11;