function makedir(directory_name)

if exist(directory_name) ==7, return; end

warning off
% R13 compatibility
if strfind(version,'R13'),
    I = findstr(directory_name,'/');
    parent_dir = directory_name(1:I(end-1));
    new_dir = directory_name(I(end-1)+1:end);
    status=mkdir(parent_dir, new_dir);
else 
    status=mkdir(directory_name);
end
warning on