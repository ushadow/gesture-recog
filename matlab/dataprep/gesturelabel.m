function [label, dict, type] = gesturelabel()
% RETURNS
% label   - cell array of gesture label string.
% type  - column vector of gesture types: 0 is discrete, 1 is continuous, 2 is rest

label = {'SwipeRight', 'SwipeLeft', 'Point', 'Rest'};
type = [0 0 1 2];
dict = containers.Map(label, 1 : length(label));
end