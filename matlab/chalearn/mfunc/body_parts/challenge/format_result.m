fid = fopen('result.csv', 'w');

mat_list = dir('*.mat');
for i=1:length(mat_list);
   filename = mat_list(i).name;
   dataset_name = filename(1:end-11);
   load(filename);
   
   start_index = 47 - numel(predicted_labels) ;
   
   for j=1:numel(predicted_labels);
      fprintf(fid, '%s_%d,',  dataset_name, j+start_index);
      
      if (length(predicted_labels{j}) >= 1)
        fprintf(fid, '%d', predicted_labels{j}(1));
      end
      for k=2:length(predicted_labels{j})
         fprintf(fid, ' %d', predicted_labels{j}(k));
      end
      fprintf(fid, '\n');
   end
end

fclose(fid);