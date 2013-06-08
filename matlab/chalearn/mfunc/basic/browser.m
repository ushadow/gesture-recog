function h=browser(databatch_name, mode, h)
%h=browser(databatch_name, mode, h)
% Creates a data browser by passing the name of a databatch object as a
% string.
% Mode is either 'M' or 'K' for regular movie a Kinect depth.
% Returns the figure handle.

% Isabelle Guyon -- isabelle@clopinet.com -- October 2011



    if nargin<2
        mode='K';
    end
    if nargin<3
        h=figure('Name', 'Movie browser');
    end
    
     
    % Next
    u0=uicontrol('Parent', h, 'Position', [10 200 60 40], 'FontSize', 12, 'BackgroundColor', [0.5 0.9 0.5], 'String', 'Next >', 'Callback', ['next(' databatch_name '); show(' databatch_name ', ''' mode ''', ' num2str(h) ');']);
    % Prev
    u1=uicontrol('Parent', h, 'Position', [10 240 60 40], 'FontSize', 12, 'BackgroundColor', [0.5 0.9 0.5], 'String', '< Prev', 'Callback', ['prev(' databatch_name '); show(' databatch_name ', ''' mode ''', ' num2str(h) ');']);
    % Jump
    u3=uicontrol('Parent', h, 'Position', [10 160 60 40], 'FontSize', 12, 'BackgroundColor', [0.9 0.7 0.2], 'String', 'Jump to', 'Callback', ['answer=inputdlg(''Enter number:'',''Jump to'',1,{num2str(num(' databatch_name '))}); goto(' databatch_name ', str2num(answer{1})); show(' databatch_name ', ''' mode ''', ' num2str(h) ');']);


    
    %eval(['show(' databatch_name ', ''' mode ''', ' num2str(h) ');']);


end

