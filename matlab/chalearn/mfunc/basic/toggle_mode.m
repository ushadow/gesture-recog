if ~exist('display_mode')
    display_mode='M';
end
if strcmp(display_mode, 'K')
    display_mode='M';
    set(u5, 'BackgroundColor', [.9 .9 0.1], 'String', 'RGB');
    if ~isempty(R), R=RM; end
else
    display_mode='K';
    set(u5, 'BackgroundColor', [0.1 .9 .9], 'String', 'Depth');
    if ~isempty(R), R=RK; end
end

% Show a movie
show(D,  display_mode, h, R);