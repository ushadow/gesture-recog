% function to prepare files for the SVM classifier
function[] = prepareData(fileName, features, classIndex)

fid = fopen(fileName,'w');
for i=1:size(features,1)
  %  i
    if(i <= classIndex)
        fprintf(fid,'1');
    else
        fprintf(fid,'-1');
    end
    for j=1:size(features,2)
        fprintf(fid,' %d:%f',j,features(i,j));
    end
    fprintf(fid,'\n');
end
fclose(fid);