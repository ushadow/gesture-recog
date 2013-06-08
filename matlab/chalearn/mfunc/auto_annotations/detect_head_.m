function head_box=detect_head_(IM1, IM2, use_kinect, debug)
%head_box=detect_head_(IM1, IM2, use_kinect, debug)
% Find the head bounding box.
% Does not work well with occlusions.
% IM1 -- first frame
% IM2 -- second frame
% use_kinect -- flag indicating whether IM is a depth image
% Returns:
% [x y w h] head box.

% Isabelle Guyon -- isabelle@clopinet.com -- February 2012

if nargin<3
    use_kinect=1;
end
if nargin<4
    debug=0;
end


[icoord, jcoord, kcoord, head_box, quality] = ini_head_n_hands(IM1, IM2, use_kinect, debug);
if quality<0.8
    % Do it again, slow version
    [icoord, jcoord, kcoord, head_box, quality] = ini_head_n_hands(IM1, IM2, use_kinect, debug, 1);
end


end