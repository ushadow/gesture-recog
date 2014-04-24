function [label, dict, type, repeat, nS, nHandPoseType] = gesturelabel(gestureDefDir)
% RETURNS
% label   - cell array of gesture label string.
% type  - column vector of gesture form types, 'D' (dynamic path), 'S'
%     (static hand pose), and 'R' (rest). There are another additional types: 'O' for
%     'Other' which are nongestures, and 'OP' for 'OtherPose' which are
%     user errors.
% nS - a vector of number of hidden states for each gesture excluding 'Other'
%   and 'OtherPose'.

% The first line is comment.
data = importdata(fullfile(gestureDefDir, 'gesture_def.txt'), ...
                  ',', 1);
label = data.textdata(2 : end, 1);
label{end + 1} = 'Rest';
label{end + 1} = 'Other'; % small movement without nucleus
label{end + 1} = 'OtherPose'; % wrong gesture should be ignored

type = data.textdata(2 : end, 2);
type{end + 1} = 'R'; % Rest
type{end + 1} = 'O'; % Other
type{end + 1} = 'OP'; % OtherPose

repeat = data.data(:, 1);
repeat(end + 1) = 0; % Rest
nS = data.data(:, 2);
nS(end + 1) = 1; % Rest
dict = containers.Map(label, 1 : length(label));

nHandPoseType = sum(strcmp(type, 'S')) + 1;
end