function [ S ] = strjoin( C, separator )
%STRJOIN Convert array to char and concatenate with separator
% Syntax
%   S = strjoin(C)
%   S = strjoin(C, separator)
%
% Description
%   S = strjoin(C) takes an array C and returns a string S which
%   concatenates array elements with comma. C can be a cell array
%   of strings, a character array, or a numeric array. If C is a
%   matrix, it is first flattened to get an array and concateneted.
%   
%   S = strjoin(C, separator) also specifies separator to be used
%   for string concatenation. The default separator is comma.
%
% Example
%   >> str = strjoin({'this','is','a','cell','array'})
%   str =
%   this,is,a,cell,array
%   >> str = strjoin(char({'this','is','a','char','array'}))
%   str =
%   this,is,a,char,array
%   >> str = strjoin([1,2,2],'_')
%   str =
%   1_2_2
%   >> str = strjoin({1,2,2,'string'},'\t')
%   str =
%   1	2	2	string
%
% Author
%   Kota Yamaguchi 2011

% Separator option
sep = ',';
if nargin > 1
    if ~ischar(separator), separator = char(separator); end
    separator = regexprep(separator,'%','%%');
    sep = sprintf(separator);
end

% Convert to cellstr
if isnumeric(C)
    C = arrayfun(@(x) num2str(x),C,'UniformOutput',false);
end
if ischar(C), C = cellstr(C); end
if ~iscell(C), error('StrJoin:InvalidArgument','Invalid argument'); end
C = reshape(C,[1,numel(C)]);
for i = 1:length(C)
    if isnumeric(C{i}), C{i} = num2str(C{i}); end
end

% Concatenate
C = [C; [repmat({sep},[1,length(C)-1]),{''}]];
C = C(:)';
S = horzcat(C{:});

end

