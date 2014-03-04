function [label, dict, type, repeat, nS] = gesturelabel(gestureDefDir)
% RETURNS
% label   - cell array of gesture label string.
% type  - column vector of gesture types
% nS - a vector of number of hidden states for each gesture excluding 'Other'
%   and 'OtherPose'.

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