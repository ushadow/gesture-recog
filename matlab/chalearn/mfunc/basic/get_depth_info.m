function [mini, maxi, set_list, num_list]=get_depth_info(depth_file, set, num)
%[mini, maxi, set_list, num_list]=get_depth_info(depth_file, set, num)
% Get the original depth normalization coefficients
% depth_file -- File with the depth coeff
% set        -- Batch type (devel, valid, final)
% num        -- Batch number.

% Isabelle Guyon -- isabelle@clopinet.com -- May 2012

if nargin<3, set=[]; end
if nargin<3, num=[]; end

fid=fopen(depth_file);
tline = fgetl(fid);
k=1;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    
    sep=strfind(tline, sprintf('\t'));
    set_list{k}=tline(1:sep(1));
    num_list(k)=str2num(tline(sep(1)+1:sep(2)));
    mini(k)=str2num(tline(sep(2)+1:sep(3)));
    maxi(k)=str2num(tline(sep(3)+1:sep(4)));
    k=k+1;
end
fclose(fid);

if ~isempty(set)
    idx=strmatch(set, set_list);
    i=find(num_list(idx)== num);
    mini=mini(idx(i));
    maxi=maxi(idx(i));

end

