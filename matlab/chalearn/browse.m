function browse(batchName)
% Args:
% - batchName: string, e.g. 'devel01'.

% 1) User-defined directories (no slash at the end of the names):

myRoot = '/home/yingyin/workspace/tabletop/gesture-recog'; % Change that to the directory of your project

dataDir = [myRoot '/data'];        % Path to the data.

useRecog   = 0; % Use a recognizer to process the examples

% Initialize the mode of display RGB ('M') or Depth ('K')
displayMode='K';

h=figure('Name', 'Movie browser');

[D, R] = showBatch([dataDir '/' batchName], useRecog, displayMode, h);

% Movie navigation
uicontrol('Position', [10 280 60 20], 'BackgroundColor', [0 0 0], ...
          'ForegroundColor', [1 1 1], 'String', 'Movie:', 'FontSize', 10);
% Next
uicontrol('Parent', h, 'Position', [10 200 60 40], 'FontSize', 12, ...
          'BackgroundColor', [0.5 0.9 0.5], 'String', 'Next >', ...
          'Callback', {@nextMovie, D, displayMode, h, R});
% Prev
uicontrol('Parent', h, 'Position', [10 240 60 40], 'FontSize', 12, ...
          'BackgroundColor', [0.5 0.9 0.5], 'String', '< Prev', ...
          'Callback', 'prev(D); show(D, displayMode, h, R);');
% Jump to another movie in the same batch
uicontrol('Parent', h, 'Position', [10 160 60 40], 'FontSize', 12, ...
          'BackgroundColor', [0.9 0.7 0.2], 'String', 'Jump to', ...
          'Callback', 'answer=inputdlg(''Enter number:'',''Jump to'',1,{num2str(num(D))}); if ~isempty(answer), goto(D, str2num(answer{1})); show(D, displayMode, h, R); end');
% Jump to another batch
uicontrol('Parent', h, 'Position', [10 360 120 40], 'FontSize', 12, 'BackgroundColor', [0.1 0.1 0.5], 'ForegroundColor', [1 1 1], 'String', 'Change batch >>', 'Callback', 'batchName = input(''Batch name:''); D = showBatch([dataDir ''/'' batchName], useRecog, displayMode, h);');
% Toggle RGB and Depth
uicontrol('Position', [10 140 60 20], 'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'String', 'Toggle:', 'FontSize', 10);
uicontrol('Parent', h, 'Position', [10 100 60 40], 'FontSize', 12, 'BackgroundColor', [.9 .9 0.1], 'String', 'RGB', 'Callback', 'toggle_mode');
end

function nextMovie(~, ~, D, displayMode, h, R)
next(D); 
show(D, displayMode, h, R);
end