function [labels, samples]=read_file(filename, debug)
%[labels, samples, fnum, ftype]=read_file(filename, debug)
% Read a label or prediction file
% and return 
% labels -- array labels, each element with a vector
% of labels corresponding to one line in the file.
% samples -- For csv files in which the first column is the sample ID
% returns also samples that are the sample IDs.
% For csv files in which the ID is not just a number but validxx_yy
% or finalxx_yy, converts the ID to a number:
% valid => 1, final to 2.
% hence 1xxyy or 2xxyy will be the IDs.
% If the second output argument is omitted, the samples are ordered in
% increasing order of sample ID.

%Isabelle Guyon -- October 2011 -- isabelle@clopinet.com

if nargin<2
    debug=1;
end

% Probe to see whether the file has a line ID + comma + space separated
% values or + comma separated values.
fid=fopen(filename);
csv=0;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    s=strfind(tline, ',');
    if length(s)>1
        csv=2;
        break;
    elseif length(s)==1
        csv=1;
    end
end

fclose(fid);

fid=fopen(filename);
i=1;
j=1;
labels={};
uval=[];
uns=0;
samples=[];

while 1
    tline = fgetl(fid);
    tline0=tline;
    if ~ischar(tline), break, end
    if uns || ~isempty(strfind(tline, '_')) || ~isempty(strfind(tline, 'valid')) || ~isempty(strfind(tline, 'final')) || ~isempty(strfind(tline, 'verif')) || ~isempty(strfind(tline, 'devel'))
        uns=1; 
    end 
    n1=''; n2='';
    if uns
        tline0=tline;
        tline=tline(6:end);
        if strfind(tline0, 'valid')==1
            n1='1';
        elseif strfind(tline0, 'final')==1
            n1='2';
        elseif strfind(tline0, 'verif')==1
            n1='3';
        elseif strfind(tline0, 'devel')==1
            n1='4';
        elseif ~isempty(tline0)
            tline=tline0;
            fprintf('Line %d has a bad type name (skipped): "%s"\n', j, tline0);
            j=j+1;
            continue; % skip this line
        elseif isempty(tline0)
            continue;
        end
        unsidx=strfind(tline, '_');
        if isempty(unsidx)
            fprintf('Line %d has a missing underscore (skipped): "%s"\n', j, tline0);
            j=j+1;
            continue; % skip this line
        end 
        n2=tline(1:unsidx(1)-1);
        nn2=str2num(n2);
        if isempty(nn2)
            fprintf('Line %d has a bad set number (skipped): "%s"\n', j, tline0);
            j=j+1;
            continue; % skip this line
        end 
        if nn2<1 %|| nn2>20
            fprintf('Line %d has a bad set number (skipped): "%s"\n', j, tline0);
            j=j+1;
            continue; % skip this line
        end
        tline=tline(unsidx+1:end);
    end
    L=[];
    if csv 
        if csv==2
            csvidx=strfind(tline, ',');
            L=sscanf(tline, '%d,')';
        else
            c=strfind(tline, ',');
            L(1)=str2num(tline(1:c(1)-1));
            tline=tline(c(1)+1:end);
            csvidx=[];
            LL=sscanf(tline, '%d')';
            L=[L LL];
        end
        
        if isempty(L)
            fprintf('Line %d empty or has bad characters (skipped): "%s"\n', j, tline0);
            j=j+1;
            continue; % skip this line
        end
        if isempty(L(1)<1||L(1)>47)
            fprintf('Line %d has a sample number out of bounds (skipped): "%s"\n', j, tline0);
            j=j+1;
            continue; % skip this line
        end
        samples(i)=str2num([n1 n2 sprintf('%02d', L(1))]);
        %[type,set,num]=split_id(samples(i)); %sanity check
        
        labels{i}=L(2:end); 
        if debug==2
            if isempty(L(2:end))
                fprintf('Line %d has an empty result or bad characters (kept): "%s"\n', j, tline0);
            elseif length(csvidx)~=length(labels{i})
                fprintf('Line %d has a comas at end or bad characters (kept): "%s"\n', j, tline0);
            end
        end     
    else
        labels{i}=sscanf(tline, '%d')';
    end
    
    uval=[uval, labels{i}];
    i=i+1;
    j=j+1;
end
fclose(fid);
uval=unique(uval);
if ~uns && (length(labels)~=47 && length(labels)~=47-length(uval) && length(labels)~=length(uval)), error('Bad label file'); end

if isempty(samples), samples=1:length(labels); end

if nargout<1
    [ss, ii]=sort(samples);
    labels=labels(ii);
end
