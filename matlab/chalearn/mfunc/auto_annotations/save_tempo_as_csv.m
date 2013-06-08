function save_tempo_as_csv( annot_file, segment_dir )
%save_tempo_as_csv( annot_file, segment_dir )
% Convert the temporal segmentation of Univ. Texas to csv, and write them to
% annot_file
%
% Each Matlab file in segment_dir contains two cell arrays of length 47
% (number of movies):
% saved_annotation  -- Each element is a matrix (n,2) where n is the number
% of gestures in the movie. Each line corresponds to the frame number of
% the beginning and end of the gesture.
% truth_labels      -- Each element is a vector of labels. Normally the
% number of labels is equal to n, except in some cases in which the user
% did not perform all the assigned gestures.
%
% Convert to csv files with fields:
% dataset_name videos gestures labels Start End


% Isabelle Guyon -- isabelle@clopinet.com -- February 2012

fp=fopen(annot_file, 'w');

fprintf(fp, 'dataset_name,videos,gestures,labels,Start,End\n');

N=47; % number of movies per batch
M=20; % number of batches

for k=1:M
    
    fprintf('%d ', k);
    
    data_name=sprintf('devel%02d', k);
    load([segment_dir '/' data_name]);
    
    for movie_num=1:N
        
        tempo_seg=saved_annotation{movie_num};
        labels=truth_labels{movie_num};
    
        T=size(tempo_seg,1);
        if length(labels)>T
            labels=labels(1:T);
        end
        if length(labels)<T
            for i=length(labels)+1:T
                labels(i)=0;
            end
        end
    
        for k=1:T
            fprintf(fp, '%s,%d,%d,%d', data_name, movie_num, k, labels(k));
            fprintf(fp, ',%d,%d\n', tempo_seg(k, 1), tempo_seg(k, 2));
        end
    end 
end

fclose(fp);



 