function hText = yticklabel_rotate(YTick, rot, varargin)
%hText = yticklabel_rotate(YTick,rot,XTickLabel,varargin)     Rotate YTickLabel
%
% Syntax: yticklabel_rotate
%
% Input:    
% {opt}     YTick       - vector array of YTick positions & values (numeric) 
%                           uses current YTick values or YTickLabel cell array by
%                           default (if empty) 
% {opt}     rot         - angle of rotation in degrees, 90 degree by default
% {opt}     XTickLabel  - cell array of label strings
% {opt}     [var]       - "Property-value" pairs passed to text generator
%                           ex: 'interpreter','none'
%                               'Color','m','Fontweight','bold'
%
% Output:   hText       - handle vector to text labels
%
% Example 1:  Rotate existing YTickLabels at their current position by 90
% degree
%    yticklabel_rotate
%
% Example 2:  Rotate existing XTickLabels at their current position by 45 degree and change
% font size
%    yticklabel_rotate([],45,[],'Fontsize',14)
%
% Example 3:  Set the positions of the YTicks and rotate them 90 degree
%    figure;  plot([1960:2004],randn(45,1)); xlim([1960 2004]);
%    yticklabel_rotate([1960:2:2004]);
%
% Example 4:  Use text labels at YTick positions rotated 45 degree without tex interpreter
%    yticklabel_rotate(YTick,45,NameFields,'interpreter','none');
%
% Example 5:  Use text labels rotated 90� at current positions
%    yticklabel_rotate([],90,NameFields);
%
% Note : you can not RE-RUN yticklabel_rotate on the same graph. 
%

% Based on xticklabel_rotate
% Brian FG Katz
% bfgkatz@hotmail.com
% 23-05-03

% check to see if xticklabel_rotate has already been here (no other reason for this to happen)
if isempty(get(gca, 'YTickLabel')),
    error('yticklabel_rotate : can not process, either yticklabel_rotate has already been run or YTickLabel field has been erased')  ;
end

% if no XTickLabel AND no XTick are defined use the current XTickLabel
%if nargin < 3 & (~exist('XTick') | isempty(XTick)),
% Modified with forum comment by "Nathan Pust" allow the current text labels to be used and property value pairs to be changed for those labels
if (nargin < 3 || isempty(varargin{1})) && (~exist('YTick', 'var') || isempty(YTick)),
	yTickLabels = get(gca, 'YTickLabel')  ; % use current XTickLabel
	if ~iscell(yTickLabels)
		% remove trailing spaces if exist (typical with auto generated XTickLabel)
		temp1 = num2cell(yTickLabels,2)         ;
		for loop = 1:length(temp1),
			temp1{loop} = deblank(temp1{loop})  ;
		end
		yTickLabels = temp1                     ;
	end
varargin = varargin(2:length(varargin));	
end

% if no XTick is defined use the current XTick
if (~exist('YTick', 'var') || isempty(YTick)),
    YTick = get(gca,'YTick')        ; % use current XTick 
end

%Make XTick a column vector
YTick = YTick(:);

if ~exist('yTickLabels', 'var'),
	% Define the xtickLabels 
	% If XtickLabel is passed as a cell array then use the text
	if (~isempty(varargin)) && (iscell(varargin{1})),
        yTickLabels = varargin{1};
        varargin = varargin(2:length(varargin));
	else
        yTickLabels = num2str(YTick);
	end
end    

if length(YTick) ~= length(yTickLabels),
    error('yticklabel_rotate : must have same number of elements in "YTick" and "YTickLabel"')  ;
end

%Set the Xtick locations and set XTicklabel to an empty string
set(gca,'YTick',YTick,'YTickLabel','')

if nargin < 2,
    rot = 90 ;
end

% Determine the location of the labels based on the position
% of the ylabel
hyLabel = get(gca, 'YLabel');  % Handle to ylabel

% if ~isempty(xLabelString)
%    warning('You may need to manually reset the XLABEL vertical position')
% end

set(hyLabel,'Units','data');
yLabelPosition = get(hyLabel,'Position');
x = yLabelPosition(1);

%CODE below was modified following suggestions from Urs Schwarz
x = repmat(x, size(YTick, 1), 1);
% retrieve current axis' fontsize
fs = get(gca, 'fontsize');

% Place the new xTickLabels by creating TEXT objects
hText = text(x, YTick, yTickLabels, 'fontsize', fs);

% Rotate the text objects by ROT degrees
%set(hText,'Rotation',rot,'HorizontalAlignment','right',varargin{:})
% Modified with modified forum comment by "Korey Y" to deal with labels at top
% Further edits added for axis position
set(hText, 'units', 'pixel');
sizes = get(hText, 'extent');
if (~iscell(sizes))
  sizes = {sizes};
end
set(hText,'Rotation',rot, varargin{:});
for i = 1 : length(hText)
  pos = get(hText(i), 'position');
  set(hText(i), 'Position', [pos(1) pos(2) - sizes{i}(3) / 4 0]);
end

set(hText,'units','normalized');

if nargout < 1,
    clear hText
end

