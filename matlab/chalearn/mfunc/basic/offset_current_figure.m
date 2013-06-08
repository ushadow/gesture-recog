function offset_current_figure(offset)
%offset_current_figure(offset)
%   Shifts the figure position by value offset

set(gcf, 'Position', get(gcf, 'Position')+[offset -offset 0 0]);

end

