function [label, dict] = gesturelabel()
% RETURNS
% label   - cell array of gesture label string.

label = {'SwipeRight', 'SwipeLeft'};

dict = containers.Map(label, 1 : length(label));
end