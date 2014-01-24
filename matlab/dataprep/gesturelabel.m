function [label, dict, type, typeNames] = gesturelabel()
% RETURNS
% label   - cell array of gesture label string.
% type  - column vector of gesture types: 0 is discrete, 1 is continuous, 2 is rest

label = {'SwipeRight', 'SwipeLeft', 'Point', 'Rest'};
typeNames = {'Unknown', 'Point', 'Rest'};
type = [1 1 2 3];
dict = containers.Map(label, 1 : length(label));
end