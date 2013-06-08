function cases=list_choices(filename)
%cases=cases=list_choices(filename)
% List all the cases of the example file.

% Isabelle Guyon -- isabelle@clopinet.com -- May 2012

fid=fopen(filename);
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    fcase=strfind(tline, 'case');
    if fcase
        num=str2num(tline(fcase+5:end));
        if num>0
            comment=fgetl(fid);
            sep=strfind(comment, '--');
            comment=comment(sep(1)+3:sep(2)-1);
            cases{num}=comment;
        end
    end
        
end
fclose(fid);

end

