function extract_unsupervised_training_data_hw2_hj_perbatch(datag,train_video_dir, result_filename, params, MTY)



spatial_size = params.spatial_size;
temporal_size = params.temporal_size;
num_patches = params.num_patches;

% dirlist = dir([train_video_dir, ['\' MTY '*']]);
% for i=1:length(dirlist),
%     train_filenames{i}=dirlist(i).name;
% end
% predirlist = dir([train_video_dir, batchz '*']);
% dc=1;
% dirlist = [];
% for i=1:length(predirlist),
%     cdirlist=dir([train_video_dir predirlist(i).name '\' , MTY '_*']);
%     dirlist = [dirlist; cdirlist];
%     num_clips_temp = length(cdirlist);    
%     for j = 1 : num_clips_temp, 
%         train_filenames{dc} = [predirlist(i).name '\' cdirlist(j).name];
%         dc=dc+1;
%     end
%     clear cdirlist num_clips_temp;
% end


% dirlist = dir([train_video_dir, MTY '_*']);
% num_clips = length(dirlist);
% train_filenames = cell(num_clips, 1); 
% for i = 1 : num_clips
%     train_filenames{i} = dirlist(i).name;
% end

[X] = sample_video_blks(datag,train_video_dir, [], spatial_size, temporal_size, num_patches, MTY);

save(result_filename, 'X', 'spatial_size', 'temporal_size', '-v7.3');
end

function [X] = sample_video_blks(datag,path, filenames, sp_size, tp_size, num_perclip, MTY)

% eval(['load C:\GestureRecognitionChallenge\Challenge\3\Tempo_segment\tempo_segment\' datag.dataname '.mat']);

num_clips = length(datag);

X = zeros(sp_size^2*tp_size, num_perclip*num_clips);

margin = 5;
counter = 1;

for i = 1 : num_clips
%     filename = [path, filenames{i}];
%     fprintf('loading clip: %s\n', filename);
    goto(datag, i);
    
% %     if datag.current_index<10
% %         vifile=[datag.datapath datag.dataname '/0' num2str(datag.current_index) '' ];
% %     else
%         vifile=[datag.datapath datag.dataname '/' MTY '_' num2str(datag.current_index) '.avi'];
% %     end
    if strcmp('K',MTY),
        V=datag.current_movie.K;
    else
        V=datag.current_movie.M;
    end    
%     cuix=saved_annotation{datag.current_index};
%     V=V(cuix(1):cuix(2));
    
    
    M = loadclip_3dm(V, sp_size, 0, 0);
%     M = loadclip_3dm(vifile, sp_size, 0, 0);
    if ~isempty(datag.cuts)
        M=M(:,:,datag.cuts{datag.current_index}(1):datag.cuts{datag.current_index}(2));
    end

    [dimx, dimy, dimt] = size(M);
    
    for j = 1 : num_perclip
        %%% Prevents processing videos that last less than tp_size-frames
        if dimt>=tp_size+1,
            %(NOTE) fix the error 
            x_pos = randi([1+margin, dimx-margin-sp_size+1]);
            y_pos = randi([1+margin, dimy-margin-sp_size+1]);
%             t_pos = randi([1, dimt-tp_size+1]);
            t_pos = randi([1, max(dimt-tp_size+1,1)]);
    %         blk = M(x_pos: x_pos+sp_size-1, y_pos: y_pos+sp_size-1, t_pos: min(t_pos+tp_size-1,dimt));
            blk = M(x_pos: x_pos+sp_size-1, y_pos: y_pos+sp_size-1, t_pos: t_pos+tp_size-1);
            X(:, counter) = reshape(blk, sp_size^2*tp_size, []);
            counter = counter + 1;
        end
    end
end

end
