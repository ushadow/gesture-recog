function [X_features, motion_measure, ds_sections] = transact_dense_samp(M, network, params)

fovea = network.isa{params.feature.num_layers}.fovea;

ds_st_per_cf_x = params.testds_sp_strides_per_cfovea_x;
ds_st_per_cf_y = params.testds_sp_strides_per_cfovea_y;
ds_st_per_cf_t = params.testds_tp_strides_per_cfovea;

ds_st_sp_x = params.testds_sp_stride_x;
ds_st_sp_y = params.testds_sp_stride_y;
ds_st_tp = params.testds_tp_stride;

[x, y, t] = size(M);
approx_num_samples = max(1, floor((x/fovea.spatial_size-2)*(y/fovea.spatial_size-2)*(t/fovea.temporal_size-2)));

ds_multiple = ds_st_per_cf_x*ds_st_per_cf_y*ds_st_per_cf_t;

%initialization of feature list
X_features = zeros(approx_num_samples*ds_multiple, params.num_features, 'single');    

%initialize motion measure (list)
motion_measure = zeros(approx_num_samples*ds_multiple, 1);

%% start dense sampling: load and calculate features for movies, starting with various offsets
X_fill = 0;
ds_count = 1;
for x_offset = 0:ds_st_per_cf_x-1 %stride indices per complex fovea
    for y_offset = 0:ds_st_per_cf_y-1 %stride indices per complex fovea
        for t_offset = 0:ds_st_per_cf_t-1
            
            N = crop_video_blk(M(1+x_offset*ds_st_sp_x:end, 1+y_offset*ds_st_sp_y:end, 1+t_offset*ds_st_tp:end), fovea.spatial_size, fovea.temporal_size);
            x_height = size(N, 1);
            num_frames = size(N, 3);
            
            N = reshape(N, x_height, []);
            
            N = im2col(N, [fovea.spatial_size, fovea.spatial_size], 'distinct');
            
            N = reshape(N, [], num_frames);
            
            N = im2col(N, [fovea.spatial_size^2, fovea.temporal_size], 'distinct');
            
            num_samples = size(N,2);
            
            %% PLUG FEATURE CALCULATION
            % N is matrix with cols as reshaped cubic patches for the whole movie clip (sp_size
            % * sp_size * tpsize X num_patches_in_clip)
            
            if params.feature.num_layers == 1
                act_l1 = activateISA(N, network.isa{1}, params.postact.layer1);                                
                
                X_features(X_fill+1:X_fill+num_samples, :) = act_l1';
                motion_measure(X_fill+1:X_fill+num_samples, 1) = sum(abs(act_l1), 1)';
                
            elseif params.feature.num_layers == 2                                                    
            
                [act_l2, act_l1_pca_reduced, l1_motion] = activate2LISA(N, network.isa{1}, network.isa{2}, size(N,2), params.postact);
                act = [act_l2; act_l1_pca_reduced];

                X_features(X_fill+1:X_fill+num_samples, :) = act';
                
                % store motion measure
                motion_measure(X_fill+1:X_fill+num_samples, 1) = l1_motion';                                                
            end
            
            ds_sections(ds_count).start = X_fill+1;            
            
            X_fill = X_fill + num_samples;
            
            ds_sections(ds_count).end = X_fill;
            
            ds_count = ds_count + 1;
        end
    end
end
end
