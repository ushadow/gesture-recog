function [] = extract_unsupervised_training_data_hw2(train_video_dir, result_filename, params)

spatial_size = params.spatial_size;
temporal_size = params.temporal_size;
num_patches = params.num_patches;

% dirlist = dir([train_video_dir, 'actioncliptrain*']);
dirlist = dir([train_video_dir, 'K_*']);
num_clips = length(dirlist);
train_filenames = cell(num_clips, 1); 
for i = 1 : num_clips
    train_filenames{i} = dirlist(i).name;
end

X = sample_video_blks(train_video_dir, train_filenames, spatial_size, temporal_size, num_patches);

save(result_filename, 'X', 'spatial_size', 'temporal_size', '-v7.3');
end

function X = sample_video_blks(path, filenames, sp_size, tp_size, num_perclip)

num_clips = length(filenames);

X = zeros(sp_size^2*tp_size, num_perclip*num_clips);

margin = 5;
counter = 1;

for i = 1 : num_clips
    filename = [path, filenames{i}];
    fprintf('loading clip: %s\n', filename);
    M = loadclip_3dm(filename, sp_size, 0, 0);
    
    [dimx, dimy, dimt] = size(M);
    
    for j = 1 : num_perclip
        %(NOTE) fix the error 
        x_pos = randi([1+margin, dimx-margin-sp_size+1]);
        y_pos = randi([1+margin, dimy-margin-sp_size+1]);
        t_pos = randi([1, dimt-tp_size+1]);
        
        blk = M(x_pos: x_pos+sp_size-1, y_pos: y_pos+sp_size-1, t_pos: t_pos+tp_size-1);
        X(:, counter) = reshape(blk, sp_size^2*tp_size, []);
        counter = counter + 1;
    end
end

end
