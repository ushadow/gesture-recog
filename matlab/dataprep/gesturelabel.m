function [label, dict, type, repeat, nS] = gesturelabel(gestureDefDir)
% RETURNS
% label   - cell array of gesture label string.
% type  - column vector of gesture types

% label = {'SwipeRight', 'SwipeLeft', 'Circle', 'ShakeHand', 'Point', ...
%          'PalmUp', 'Rest'};
% repeat = [0 0 0 1 0 0 0];
% type = [1 1 1 1 2 3 4];
% nS = [4, 3, 4, 4, 1, 1, 1];

data = importdata(fullfile(gestureDefDir, 'workspace\handinput\GesturesViewer\Data\Gestures.txt'), ...
                  ',', 1);
label = data.textdata(2 : end, 1);
label{end + 1} = 'Other'; % small movement without nucleus
label{end + 1} = 'OtherPose'; % wrong gesture should be ignored
type = data.textdata(2 : end, 2);
type{end + 1} = 'O'; % Other
type{end + 1} = 'OP';
repeat = data.data(:, 1);
nS = data.data(:, 2);
dict = containers.Map(label, 1 : length(label));
end