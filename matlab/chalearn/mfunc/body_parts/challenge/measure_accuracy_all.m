% directories;
% first_list = dir( sprintf('%s/', challenge_data_directory) );
% 
% for i=1:length(first_list)
%    
%     if  ( (first_list(i).isdir==0) || (strcmp(first_list(i).name, '.') == 1) || (strcmp(first_list(i).name, '..') == 1) )
%         continue;
%     end
%     
%     second_list = dir( sprintf('%s/%s/', challenge_data_directory, first_list(i).name ) );
%     for j=1:length(second_list)
%        
%         if  ( (second_list(j).isdir == 0) || (strcmp(second_list(j).name, '.') == 1) || (strcmp(second_list(j).name, '..') == 1) )
%             continue;
%         end
%         
%         experiment_folder = sprintf('%s/%s', first_list(i).name, second_list(j).name);
%         try
%             measure_accuracy(experiment_folder);
%         catch err
%            fid = fopen('error.txt', 'a');
%            fprintf(fid, 'error in \"%s\" : %s\n', experiment_folder, err.message);
%            
%            fclose(fid);
%         end
%        % fid = fopen('result.txt', 'a');
%        % fprintf(fid, '%s\n', experiment_folder);
%        % fclose(fid);
%     end
%     
%      
% end

directories;
second_list = dir( sprintf('%s/valid*', challenge_data_directory) );
for j=1:length(second_list)
       
        if  ( (second_list(j).isdir == 0) || (strcmp(second_list(j).name, '.') == 1) || (strcmp(second_list(j).name, '..') == 1) )
            continue;
        end
        
        experiment_folder = sprintf('%s', second_list(j).name);
        %disp(experiment_folder);
        try
            measure_accuracy(experiment_folder);
        catch err
           fid = fopen('error.txt', 'a');
           fprintf(fid, 'error in \"%s\" : %s\n', experiment_folder, err.message);
           
           fclose(fid);
        end
      
end