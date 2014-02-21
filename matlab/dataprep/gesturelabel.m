function [label, dict, type, repeat, nS] = gesturelabel()
% RETURNS
% label   - cell array of gesture label string.
% type  - column vector of gesture types

% label = {'SwipeRight', 'SwipeLeft', 'Circle', 'ShakeHand', 'Point', ...
%          'PalmUp', 'Rest'};
% repeat = [0 0 0 1 0 0 0];
% type = [1 1 1 1 2 3 4];
% nS = [4, 3, 4, 4, 1, 1, 1];

data = importdata('G:\workspace\handinput\GesturesViewer\Data\Gestures.txt', ...
                  ',', 1);
label = data.textdata(2 : end, 1);
type = data.textdata(2 : end, 2);
repeat = data.data(:, 1);
nS = data.data(:, 2);
dict = containers.Map(label, 1 : length(label));
end