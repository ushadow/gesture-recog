%train stacked ISA

%this function trains bases for layers of stacked isa model

function [] = train_isa(network, train_data_filename, bases_path, params)

fprintf('\n----------------------------------------\n');
fprintf('start training layer %d\n', params.layer);

fprintf('------- load training patches: --------- \n');
load(train_data_filename);

if params.layer ==2
    fprintf('------- Forw Prop layer 1: --------- \n');

    X = single(transactConvISA(X, network.isa{1}, network.isa{2}, params.postact.layer1));
elseif params.layer ==3
    fprintf('------- Forw Prop layers 1 and 2: --------- \n');   
    [X, ~, ~, ~, act_l1_pool_list] = transactConvISA2layers(network, X, params.pool_type, params.postact);    
end

fprintf('size of X: %dx%d\n', size(X,1), size(X,2));

fprintf('Removing DC component\n')

X = removeDC(X);

if params.layer ==3
    act_l1_pool_list = removeDC(act_l1_pool_list);
end

fprintf('Doing PCA and whitening on data or prev layer activations\n')

[V,E,D] = pcaql(X);

if params.layer ==3
    fprintf('Doing PCA and whitening on layer 1 (reduced) activations\n')
    
    [V_l1l2, E, D] = pcaql(act_l1_pool_list);
end

Z = V(1:params.pca_dim , :)*X;

save_filename = [bases_path, network.isa{params.layer}.bases_id, '.mat'];

fprintf('saving bases at %s\n', save_filename);

if params.layer ==3
    isa_est(Z,V(1:params.pca_dim,:), params.pca_dim, params.group_size, network.isa{params.layer}.fovea.spatial_size, network.isa{params.layer}.fovea.temporal_size, save_filename, V_l1l2(1:params.pca_dim,:));
else
    isa_est(Z,V(1:params.pca_dim,:), params.pca_dim, params.group_size, network.isa{params.layer}.fovea.spatial_size, network.isa{params.layer}.fovea.temporal_size, save_filename);
end

end
