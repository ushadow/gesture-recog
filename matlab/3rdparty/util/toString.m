function str = toString(var, varargin)
% TOSTRING    produce string representation of any datatype
%
% S = TOSTRING(A) produces a string representation of A, where 
% class(A) can be one of 
%
%      double,   single                          
%      logical,       
%      char,          
%      int8,     uint8       
%      int16,    uint16 
%      int32,    uint32 
%      int64,    uint64  
%      cell,          
%      struct,  
%      function_handle, 
%      (user-implemented class name)   
%
% The default string represenation is as verbose as possible.
% That means the contents of structure fields, cell array 
% entries, etc. are representated in fully expanded form.
%
% S = TOSTRING(A, 'disp') produces a string representaion that 
% is identical to what the command 'disp(A)' would produce. 
%
% S = TOSTRING(A, 'compact') or S = TOSTRING(A, N) (with N a positive
% integer) limits the number of digits displayed in numerical arrays 
% to either 4 ('compact') or N. 
% 
%
% EXAMPLE 1:
%
%   >> a = struct('someField', uint32(10*rand(2)), 'otherField', {{[]}});
%   >> S = toString(a)
%
%   S =
%
%   1x1 struct:       
%    someField: [9  7]
%               [2  2]
%   otherField: { [] }
%
%
%   >> S = toString(a, 'disp')
%
%   S =
%
%        someField: [2x2 uint32]
%       otherField: []
%
%
%   EXAMPLE 2: 
%
%   >> a = rand(2,2,2,2);
%   >> S = toString(rand(2,2,3,2)
%
%     S =
% 
%       (:,:,1,1) =                                  
%       [5.501563428984222e-01	5.870447045314168e-01]
%       [6.224750860012275e-01	2.077422927330285e-01]
% 
%       (:,:,1,2) =                                  
%       [4.356986841038991e-01	9.233796421032439e-01]
%       [3.111022866504128e-01	4.302073913295840e-01]
% 
% 
%       (:,:,2,1) =                                  
%       [3.012463302794907e-01	2.304881602115585e-01]
%       [4.709233485175907e-01	8.443087926953891e-01]
% 
%       (:,:,2,2) =                                  
%       [1.848163201241361e-01	9.797483783560852e-01]
%       [9.048809686798929e-01	4.388699731261032e-01]
% 
% 
% EXAMPLE 3: 
%
%   >> a = cellfun(@(~)rand(3), cell(2), 'uni',false);
%   >> a{end} = cell(2);
%   >> a{end}{end} = @sin;
%   >> S = toString(a, 2)
%
%   S = 
%
%      {  [0.01   0.92   0.42]  [0.61   0.24   0.77]  }
%      {  [0.60   0.00   0.46]  [0.19   0.92   0.19]  }
%      {  [0.39   0.46   0.77]  [0.74   0.27   0.29]  }
%      {                                              }
%      {  [0.32   0.04   0.47]     {  []   []   }     }
%      {  [0.78   0.18   0.15]     {  []  @sin  }     }
%      {  [0.47   0.72   0.34]                        }
%
%
% See also disp, num2str, func2str, sprintf.


% Please report bugs and inquiries to: 
%
% Name       : Rody P.S. Oldenhuis
% E-mail     : oldenhuis@gmail.com   (personal)
%              roldenhuis@cosine.nl  (professional)
% Affiliation: cosine measurement systems
% Licence    : GPL + anything implied by placing it on the FEX
%
% or have a look on 
%
%   http://stackoverflow.com/users/1085062/rody-oldenhuis
%   http://www.mathworks.com/matlabcentral/fileexchange/authors/45753
   

    
    %% initialize
          
    multiD    = false;
    numDigits = inf; % maximum precision
    if nargin >= 2
        if ischar(varargin{1})
            
            switch lower(varargin{1})
                
                % return same as disp would print
                case 'disp'
                    str = evalc('disp(var)');
                    return;  
                    
                % return same as disp would print
                case 'compact'
                    numDigits = 4; %                    
                    
                % RECURSIVE CALL (FOR MULTI-D ARRAYS)
                % LEAVE UNDOCUMENTED
                case 'recursive_call'
                    multiD   = true;
                    indexString = varargin{2};
                    numDigits = varargin{3};
                    
                otherwise
                    error(...
                        'toString:unknown_option',...
                        'Unknown option: %s.', varargin{1});
            end
        
        % manually pass number of digits
        elseif isscalar(varargin{1}) && isnumeric(varargin{1})
            numDigits = max(1, round(varargin{1}));
            
        else
            error(...
                'toString:invalid_second_argument',...
                'Second argument to toString must be a string.');
        end
    end
    
    
    %% generate strings
    
    % handle multi-D variables 
    if ~isstruct(var) % NOT for structures
        if ndims(var)>=3
            
            a = repmat({':'}, 1,ndims(var)-3);
            
            str = [];
            for ii = 1:size(var,3)
                if ~multiD % first call
                    str = char(...
                        str, ...
                        toString( ...
                            squeeze(var(:,:,ii,a{:})), ...
                            'recursive_call', ['(:,:,' num2str(ii)],...
                            numDigits)...
                        );
                    
                else % subsequent calls
                    str = char(...
                        str, ...
                        toString( ...
                            squeeze(var(:,:,ii,a{:})), ...
                            'recursive_call', [indexString ',', num2str(ii)],...
                            numDigits), ...
                        '');
                end
            end
            
            return
            
        elseif multiD % last call
            str = char(...
                [indexString ') = '],...
                toString(var, numDigits));
            return
            
        end
    end
        
    % Empties first
    if isempty(var)
        
        if ischar(var)
            str = '''''';
            
        elseif iscell(var)
            str = '{}';
            
        % FIXME: delegate this somehow to where structs are handled
        elseif isstruct(var)
            fn = fieldnames(var);
            if ~isempty(fn)
                str = char(...
                    'empty struct with fields:',...
                    fn{:});
            else
                str = 'empty struct';
            end
            
        else
            str = '[]';
            
        end
        
        return
    end
    
    % simplest case: char
    if ischar(var)
        quote = repmat('''', size(var,1),1);
        str = [quote var quote];
        return
    end
    
    % ordinary numeric or logical array can be handled by num2str
    if isnumeric(var) || islogical(var)
        
        if isinteger(var) || islogical(var)            
            if ~isfinite(numDigits)
                str = num2str(var);
            else
                warning(...
                    'toString:numdigits_on_int',...
                    'The number of digits only applies to non-integer data. Ignoring...');
            end
            
        else            
            if ~isfinite(numDigits)
                if isa(var, 'double')
                    str = num2str(var, '%17.15e   ');
                elseif isa(var, 'single')
                    str = num2str(var, '%9.7e   ');
                else
                    error(...
                        'toString:unknown_class',...
                        ['Unsupported numeric class: ''', class(var), '''.']);
                end
            else
                str = num2str(var, ['%' num2str(numDigits+2) '.' num2str(numDigits), 'f   ']);
            end
            
        end
        
        if numel(var) > 1
            brO = repmat('[',size(str,1),1);
            brC = brO; brC(:) = ']';
            str = [brO  str  brC];
        end
        
        return;
        
    end
    
    % Cell arrays
    if iscell(var)
        
        strreps = cellfun(@(x)toString(x,numDigits), var, 'UniformOutput', false);
        
        rows = max(cellfun(@(x)size(x,1), strreps),[],2);
        cols = max(cellfun(@(x)size(x,2), strreps),[],1);
        
        str = [];
        for ii = 1:size(strreps,1)            
            
            space  = repmat(' ', rows(ii),2);
            braceO = repmat('{', rows(ii),1);
            braceC = braceO; braceC(:) = '}';
            
            newentry = braceO;
            for jj = 1:size(strreps,2)
                newentry = [...
                    newentry,...
                    space,...
                    center(strreps{ii,jj}, rows(ii), cols(jj))]; %#ok FIXME: growing array
            end
            newentry = [newentry space braceC]; %#ok FIXME: growing array
            
            emptyline = ['{' repmat(' ', 1,size(newentry,2)-2) '}'];
            if ii == 1                
                str = char(newentry);
                
            else
                if rows(ii) == 1 
                    str = char(str, newentry);
                else
                    str = char(str, emptyline, newentry);
                end
            end
            
        end
        
        return
    end
    
    % function handles
    if isa(var, 'function_handle')
        str = func2str(var);
        if str(1) ~= '@'
            str = ['@' str]; end
        return
    end
    
    % structures
    if isstruct(var)
        
        fn = fieldnames(var);
        
        sz = num2str(size(var).');
        sz(:,2) = 'x';  sz = sz.';
        sz = sz(:).';   sz(end) = [];
        
        if isempty(fn)
            if numel(var) == 0
                str = 'empty struct';
            else
                str = [sz ' struct with no fields.'];
            end
            
        elseif numel(var) == 1
            str = [sz ' struct:'];
            str = append_list(var, str,fn,numDigits);
            
        else
            str = char(...
                [sz ' struct array with fields:'],...
                fn{:});
        end
        
        return;
    end
    
    % If we end up here, we've been given a classdef'ed object
    % --------------------------------------------------------
    
    name   = class(var);
    
    supers = superclasses(var);
    methds = methods(var);
    props  = properties(var);
    evnts  = events(var);
    enums  = enumeration(var);
    
    % header
    if numel(supers) > 1
        supers = [
            cellfun(@(x) [x ' -> '], supers(1:end-1), 'uni', false)
            supers(end)];
        supers = [supers{:}];
    else
        supers = supers{:};
    end
    
    str = [name ', subclass of ' supers];
    
    % properties
    if ~isempty(props)
        str = char(str, '', 'Properties:', '------------');
        str = append_list(var, str,props);
    else
        str = char(str, '','', '<< No public properties >>');
    end
    
    % methods
    if ~isempty(methds)
        str = char(str, '', '', 'Methods:', '------------');
        methds = append_string(right_align(methds), '()');
        str = char(str, methds{:});
    else
        str = char(str, '','', '<< No public methods >>');
    end
    
    % enums
    if ~isempty(enums)
        str = char(str, '', '', 'Enumerations:', '------------');
        enums = right_align(enums);
        str = char(str, enums{:});
    else
        str = char(str, '','', '<< No public enumerations >>');
    end
    
    % events
    if ~isempty(evnts)
        str = char(str, '','', 'Events:', '------------');
        evnts = right_align(evnts);
        str = char(str, evnts{:});
    else
        str = char(str, '','', '<< No public events >>');
    end
    
end



% STRING MANIPULATION
% --------------------------------------------------


% pad (cell) string with spaces according to required field width
function str = prepend_space(fw, str)
    
    if iscell(str)
        str = cellfun(@(x) prepend_space(fw,x), str, 'uni', false);        
    else
        str = [repmat(' ', size(str,1),fw-length(str)) str];        
    end
    
end


% make a displayable "block" of a single key and possibly many values
function str = make_block(key, value)
    
    if size(value,1) > 1
        key = [key; repmat(' ', size(value,1)-1, size(key,2))]; end
    
    str = [key value];
end


% right-align all entries in a cell string
function list = right_align(list)
    list = prepend_space(max(cellfun(@length,list)), list);
end


% center-align (horizontal and vertical) a character array 
% according to given block size
function str = center(str, rows,cols)        
    
    [sz1, sz2] = size(str);
    
    if sz2 < cols || sz1 < rows
        
        ctr = max(1, ceil([rows/2-(sz1-1)/2  cols/2-(sz2-1)/2]));
        newstr = repmat(' ', rows,cols);        

        for ii = 1:sz1
            newstr(ctr(1)+ii-1, (0:length(str(ii,:))-1)+ctr(2) ) = str(ii,:); end        
        
        str = newstr;
    end    
end


% append a string to every entry in a cell string
function list = append_string(list, string)
    
    if iscell(list)
        list = cellfun(@(x) [x string], list, 'uni', false);
    else
        list = [list string];
    end
    
end


% append a set of keys and their evaluated values to a list
function str = append_list(var, str,list,numDigits)
    
    for ii = 1:size(list,1)
        list{ii,2} = toString(var.(list{ii,1}),numDigits); end
    
    list(:,1) = append_string(right_align(list(:,1)), ': ');
    
    for ii = 1:size(list,1)
        str = char(str, make_block(list{ii,:})); end
    
end


