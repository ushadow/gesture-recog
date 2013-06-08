function write_file(filename, samples, labels, prefix, mode, coma_end, separator)
%write_file(filename, samples, labels, prefix, mode, coma_end, separator)
% Write labels in Kaggle csv format

%Isabelle Guyon -- October 2011 -- isabelle@clopinet.com

if nargin<4 || isempty(prefix), prefix=''; end
if nargin<5 || isempty(mode), mode='w'; end
if nargin<6 || isempty(coma_end), coma_end=0; end
if nargin<7 || isempty(separator), separator=' '; end

types={'valid', 'final', 'verif', 'devel'};

fp=fopen(filename, mode);
type=[];
set=[];
for k=1:length(samples)
    if samples(k)>47
        [type,set,num]=split_id(samples(k));
        prefix=sprintf('%s%02d_', types{type}, set);
    else
        num=samples(k);
    end
    fprintf(fp, '%s%d,%s', prefix, num, separator);
    lbl=labels{k};
    if ~isempty(lbl)
        for i=1:length(lbl)-1+coma_end
            fprintf(fp, '%d%s', lbl(i), separator);
        end
        if ~coma_end
            fprintf(fp, '%d\n',  lbl(end));
        else
            fprintf(fp, '\n');
        end
    else
        fprintf(fp, '\n');
    end
end
fclose(fp);


end

