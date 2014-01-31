function [label, dict, type, repeat] = gesturelabel()
% RETURNS
% label   - cell array of gesture label string.
% type  - column vector of gesture types

label = {'SwipeRight', 'SwipeLeft', 'Circle', 'ShakeHand', 'Point', ...
         'PalmUp', 'Rest'};
repeat = [0 0 0 1 0 0 0];
type = [1 1 1 1 2 3 4];
dict = containers.Map(label, 1 : length(label));
end