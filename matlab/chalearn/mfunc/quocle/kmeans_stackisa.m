function [train_label_all, center_all, km_obj] = kmeans_stackisa(Xtrain_raw, params)

center_all = cell(params.num_km_init, 1);
% km_obj = cell(params.num_km_init, 1);
km_obj = zeros(params.num_km_init, 1);

%%--------------Do kmeans on random sampled training data------------------

tot_num_samples = 0;
for i = 1:params.num_vid_sizes
    tot_num_samples = tot_num_samples + size(Xtrain_raw{i}, 1);
end

fprintf('total number of training samples: %d\n', tot_num_samples);

sub_size = min(params.num_centroids*params.num_km_samples, tot_num_samples);

fprintf('kmeans on number of samples: %d\n', sub_size);

% random seed guarantees samples corresponding to same video positions are
% used % for different bases

rand('state', params.seed);

%down-sample Xtrain_raw

ridx = randperm(tot_num_samples);
ridx = ridx(1:sub_size);
    
line = logical(zeros(tot_num_samples, 1));
line(ridx) = logical(1);
    
Xtrain_raw_sub = [];
counter = 1;
for i = 1:params.num_vid_sizes
    blksize = size(Xtrain_raw{i},1);
    Xtrain_raw_sub = [Xtrain_raw_sub; Xtrain_raw{i}(line(counter: counter+blksize-1), :)];
    counter = counter + blksize;
end

assert(counter == (tot_num_samples+1));

for ini_idx = 1:params.num_km_init        
    fprintf('compute kmeans: %d th initialization\n', ini_idx);
    rand('state', params.seed + 10*ini_idx);

    [~, center_all{ini_idx}, km_obj(ini_idx)] = litekmeans_obj(Xtrain_raw_sub, params.num_centroids);  
end

clear Xtrain_raw_sub;

for j = 1:params.num_km_init
    fprintf('assigning all labels to train data......\n');
    for i = 1:params.num_vid_sizes
        train_label_all{j}{i} = find_labels_dnc(center_all{j}, Xtrain_raw{i});
    end
end

end
