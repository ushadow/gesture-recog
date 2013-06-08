function [res, act_l2_pool, act_l1_pool, l1_motion, act_l1_pool_list] = transactConvISA2layers(network, data, pool_type, postact)

% A combination of data transform and activations for ISA, faster & mem
% efficient
% input to a convolutional neural net
% data               : (complex fovea dimensions) (sp_size * sp_size * tp_size)
%                       x num_samples (e.g. (32*32*20) x 1000 )
% isa1               : struct with parameters of convolutional isa 

%% obtain size/stride parameters from isa1
cfovea_spsize = network.isa{3}.fovea.spatial_size;
cfovea_tpsize = network.isa{3}.fovea.temporal_size;
sfovea_spsize = network.isa{2}.fovea.spatial_size;
sfovea_tpsize = network.isa{2}.fovea.temporal_size;

spstride = network.isa{2}.spatial_stride;
tpstride = network.isa{2}.temporal_stride;

%% verify data fits specs
assert(size(data,1) == cfovea_spsize^2*cfovea_tpsize);
num_patches_cfovea = size(data,2);

%% clarify simple fovea subsamples in a complex fovea patch
numsamplesper_spcol = floor((cfovea_spsize - sfovea_spsize)/spstride+1);
numsamplesper_tpcol = floor((cfovea_tpsize - sfovea_tpsize)/tpstride+1);

num_subsamples_cfovea = numsamplesper_spcol^2*numsamplesper_tpcol;
%patch_numel_sfovea = network.isa{2}.fovea_numel;

%% number of features on weight and pooling layers
%dim_w = network.isa{2}.pca_dim;
dim_p_l2 = network.isa{2}.num_features;

%% initialize output
res = zeros(num_subsamples_cfovea*dim_p_l2, size(data, 2), 'single');
act_l1_pool_list = zeros(num_subsamples_cfovea*dim_p_l2, size(data, 2), 'single');
l1_motion = zeros(1, size(data,2), 'single');

%% reshape data into string of squares
data = reshape(data, [cfovea_spsize, size(data, 2)*cfovea_spsize*cfovea_tpsize]);

%% create a run-thru index
index = (1:size(data, 2))-1;

for it = 0: num_subsamples_cfovea-1
%    fprintf('processing subsample %d\n', it+1);
    [x, y, t] = ind2sub([numsamplesper_spcol,numsamplesper_spcol, numsamplesper_tpcol], it+1);
    startx = (x-1)*spstride+1;
    starty = (y-1)*spstride+1;
    startt = (t-1)*tpstride*cfovea_spsize+1;
    
    tailx = startx -1 + sfovea_spsize;
    
    y_filter_spatial = (mod(index, cfovea_spsize)>=starty-1)&(mod(index, cfovea_spsize)< starty+sfovea_spsize-1);
    y_filter_temporal = (mod(index, cfovea_spsize*cfovea_tpsize)>=startt-1)&(mod(index, cfovea_spsize*cfovea_tpsize)<startt+cfovea_spsize*sfovea_tpsize-1);
    
    y_filter = logical(y_filter_spatial.*y_filter_temporal);

%% use this to verify y_filter:
%     fprintf('x = %d, y = %d, t = %d, rows: %d to %d \n', x, y, t, startx, tailx)
%     for i = 0:cfovea_tpsize-1
%       fprintf('    cols in cfovea square: %d to %d\n', find(y_filter(i*cfovea_spsize+1:(i+1)*cfovea_spsize),1, 'first'), find(y_filter(i*cfovea_spsize+1:(i+1)*cfovea_spsize),1, 'last'))
%     end     

    %% data_sub: vectorized subsample patches indexed by 'it' 
    %size of data_sub: sfovea_spsize x (sfovea_spsize x sfovea_tpsize x num_samples[cfovea])
    data_sub = data(startx:tailx, y_filter);

    assert(size(data_sub, 1)==sfovea_spsize);
    assert(size(data_sub, 2)==sfovea_spsize * sfovea_tpsize * num_patches_cfovea);

    data_sub = reshape(data_sub, sfovea_spsize^2*sfovea_tpsize, num_patches_cfovea);

    %% activate isa
    [res(blkidx(dim_p_l2, it),:), act_l1_pool_list(blkidx(dim_p_l2,it),:), l1_motion_cur] = activate2LISA(data_sub, network.isa{1}, network.isa{2}, 5000, postact);
    
    l1_motion = l1_motion + l1_motion_cur;
end

if nargout < 5
    act_l2_pool = pool_layer(res, network.isa{2}, network.isa{3}, pool_type.l2tol3);
    act_l1_pool = pool_layer(act_l1_pool_list, network.isa{2}, network.isa{3}, pool_type.l1prl2tol3);
else
    act_l2_pool = 0;
    act_l1_pool = 0;
end

end
