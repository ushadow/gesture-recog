% script to tidy up calculations in parameters

% this is the fovea for each data block sampled
fovea = network.isa{params.feature.num_layers}.fovea;

% set dense sampling strides
params.testds_sp_stride_x = round(fovea.spatial_size/params.testds_sp_strides_per_cfovea_x); % e.g. 10 for 16t20
params.testds_sp_stride_y = round(fovea.spatial_size/params.testds_sp_strides_per_cfovea_y); % e.g. 10 for 16t20
params.testds_tp_stride = round(fovea.temporal_size/params.testds_tp_strides_per_cfovea); % e.g. 7 for 16t20 tp: can set this to any integer

% calculate number of features, depending on number of network layers and
% whether or not concactenate features from different layers

if params.feature.num_layers ==1
    NUM_FEATURES_L1 = network.isa{1}.num_features;     
    NUM_FEATURES = NUM_FEATURES_L1;    
elseif params.feature.num_layers ==2    
    NUM_FEATURES_L1 = network.isa{1}.num_features; 
    NUM_FEATURES_L2 = network.isa{2}.num_features;
    % options on catlayers: if cat l1+l2, current setting l1 dim = l2 dim
    if params.feature.catlayers == 2
        NUM_FEATURES = NUM_FEATURES_L2;
    elseif params.feature.catlayers == 0 % void option for l1 features only
        NUM_FEATURES = NUM_FEATURES_L2;
    elseif params.feature.catlayers == 1        
        NUM_FEATURES = 2*NUM_FEATURES_L2;
    end    
elseif params.feature.num_layers == 3
    NUM_FEATURES_L1 = network.isa{1}.num_features; 
    NUM_FEATURES_L2 = network.isa{2}.num_features;
    NUM_FEATURES_L3 = network.isa{3}.num_features;     
    if params.usekmagg == 1
        NUM_FEATURES = 3*NUM_FEATURES_L3;
    else
        NUM_FEATURES = NUM_FEATURES_L3 + network.isa{2}.num_subsamples*(2*NUM_FEATURES_L2);
    end
end
params.num_features = NUM_FEATURES;