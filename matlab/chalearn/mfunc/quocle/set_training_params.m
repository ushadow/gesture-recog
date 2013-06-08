function params = set_training_params(layer, network_params)

switch layer
    case 1
        params_l1.layer = 1;
        params_l1.pca_dim = network_params.pca_dim_l1;
        params_l1.group_size = network_params.group_size_l1;
        
        fprintf('----------------------------------------\n');
        fprintf('training layer 1 with params: \n');
        params = params_l1
    case 2
        params_l2.layer = 2;
        params_l2.pca_dim = network_params.pca_dim_l2;
        params_l2.group_size = network_params.group_size_l2;

        params_l2.feature.actl1norm = 0;
        params_l2.postact.layer1.type = 'lhthresh';
        params_l2.postact.layer1.lowthresh = 0;
        params_l2.postact.layer1.highthresh = 1;
        params_l2.postact.layer1.usegpu = 0;

        fprintf('training layer 2 with params: \n');
        params = params_l2
end
end
