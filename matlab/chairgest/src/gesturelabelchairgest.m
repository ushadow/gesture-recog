function [label, dict] = gesturelabelchairgest()
% RETURNS
% label   - cell array of gesture label string.

label = {'ShakeHand', 'WaveHello', 'SwipeRight', 'SwipeLeft', ...
  'CirclePalmRotation', 'CirclePalmDown', 'TakeFromScreen', ...
  'PushToScreen', 'PalmDownRotation', 'PalmUpRotation', 'PreStroke', ... 
  'PostStroke', 'Rest'};

dict = containers.Map(label, 1 : length(label));
end