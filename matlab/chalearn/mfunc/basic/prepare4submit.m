function prepare4submit(submitname, dirname)
%prepare4submit(submitname, dirname)
% Prepare the challenge submission by concatenating the files in the
% directory dirname and calling it submitname.predict.
% Remove all the old files upon completion.

% Isabelle Guyon -- isabelle@clopinet.com -- October 2011

direc = dir([dirname '/valid*_predict.csv']); filenames1 = {};
[filenames1{1:length(direc),1}] = deal(direc.name);
direc = dir([dirname '/final*_predict.csv']); filenames2 = {};
[filenames2{1:length(direc),1}] = deal(direc.name);
filenames=[filenames1; filenames2];

if isempty(strfind(submitname, '_predict.csv'))
    submitname=[submitname '_predict.csv'];
end

if exist(([dirname '/' submitname]), 'file')
    delete([dirname '/' submitname]);
end
        
fp=fopen([dirname '/' submitname], 'a');
for k=1:length(filenames)
    fid=fopen([dirname '/' filenames{k}], 'r');
    while 1
        tline = fgetl(fid);
        if ~ischar(tline), break, end
        fprintf(fp, '%s\n', tline);
    end
    fclose(fid);
end
fclose(fp);

for k=1:length(filenames)
    delete([dirname '/' filenames{k}]);
end