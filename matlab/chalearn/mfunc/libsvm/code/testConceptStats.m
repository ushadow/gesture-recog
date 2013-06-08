% compute statistics about the test images

clc
clear all

folder = './TestImages';

count = 1;

%conceptHist = [];
%concept = [];

for i=1:200
   i
    fid = fopen(sprintf('%s/challenge%d/challenge%d.txt',folder,i,i));
    tline = fgetl(fid);
    tline = fgetl(fid);
    for j=1:3
        tline = fgetl(fid);
        conceptTmp = tline(5:end);
         if(strcmp('money ',conceptTmp))
             i
           j
        end
        if(i==1 && j==1)
            concept{count} = conceptTmp;
            conceptHist = 1;
        else
            lim = count;
            found = 0;
            for k=1:lim
                %  fprintf('%s, %s,\n',concept{k},conceptTmp);
                if(strcmp(concept{k},conceptTmp))
                    conceptHist(k) = conceptHist(k)+1;
                    found = 1;
                    break;
                end
            end
            if(found==0)
                count = count+1;
                concept{count} = conceptTmp;
                conceptHist = [conceptHist 1];

            end
        end
    end
    fclose(fid);
end

fid  = fopen('testCategories.txt','w');
fprintf(fid,'Category\tfrequency\n\n');
for i=1:length(concept)
    fprintf(fid,'%s\t\t%-d\n',concept{i},conceptHist(i));
end
fclose(fid);

