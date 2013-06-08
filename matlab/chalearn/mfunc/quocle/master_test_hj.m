path = './'; %current folder

% ***CHANGE TO DESIRED PATHS***
datapath='C:\GestureRecognitionChallenge\Challenge\Data_small\';
batchz='devel';
MTY='K';
tridx=1:2;
teidx=3:4;

params.afspath = 'C:\GestureRecognitionChallenge\Challenge\3\Sample_code\';
params.savepath = 'C:\GestureRecognitionChallenge\Challenge\3\Sample_code\'; %path to save intermediate (before svm classification) results
% params.jacketenginepath = '/**/jacket/engine/'; % option to use Jacket GPU code for MATLAB http://www.accelereyes.com/

% option: dense sampling parameter
dense_p = 1;
% 1 for non-overlap grid sampling of features
% 2 for 50% overlap grid sampling of features
%%

% option: use GPU with Jacket 
gpu = 0;
%%

%DEFAULT SET UP FOR HOLLYWOOD2

addpath(path);
addpath([path, '/activation_functions/']);
addpath([path, '/mmread/']);
addpath([path, '/tbox/']);
addpath([path, '/svm/']);
addpath([path, '/svm/chi/']);
addpath([path, '/svm/chi/pwmetric/']);
addpath([path, '/svm/libsvm-mat-3.0-1/']);

bases_path = [path, 'bases/'];

%% number of layers
params.feature.num_layers = 2; %number of layers in the model; 2 is usually enought to give good results
params.feature.catlayers = 1; %whether or not concactenate features from different layers (if 0, only retain top activations)
params.feature.type = 'sisa'; %feature type, 'sisa' for stacked ISA

%% build network
network_params = set_network_params();
network = build_network(network_params, 2, bases_path);

%% set params

%path to videos
% params.avipath{1} = [params.afspath, 'AVIClips05/']; 
params.avipath{1} =datapath;
% %path to clipsets (label info)
% params.infopath = [params.afspath, 'ClipSets/']; %path for video labels/info
params.infopath = '';

%number of supervised train & test movies (for controlled testing)
params.num_movies = 1000; %anything >900 = train/test all movies

%vector quantization
params.num_centroids = 3000; %for kmeans feature aggregation: recommend 1e4 centroids when using linear kernel, 3000 centroids when using chi-squared kernel
params.num_km_init = 3; %number of random kmeans initializations
params.num_km_samples = 1000; %number of kmeans samples *Per Centroid*
params.seed = 10; %random seed for kmeans

%norm binning & filtering (disregard, leave values)
params.usenormbin = 1; %
params.normbinexp = 1; %
params.filtermotion = 0; %

%svm kernel
params.kernel = 'chisq';

params.pydheight = 1;

params.norm_type = 1; %normalization type for svm classification
% [L1-norm]: recommended for chi-squared svm kernel

%evaluation method: 'ap' average precision (one-vs-all, multiple labels per datapoint), 
params.eval = 'ap';

params.num_vid_sizes = 1; %[void] option to use multiple video sizes
params.unscramble = 1; %set 1 Hollywood2: deal with multiple labels/clip

% -- dense sampling params --
% how densely we sample the videos. We commonly use: 1,1,1 non-overlap,
% 2,2,2 50% overlap
params.testds_sp_strides_per_cfovea_x = dense_p; 
params.testds_sp_strides_per_cfovea_y = dense_p; 
params.testds_tp_strides_per_cfovea = dense_p; 
% -- --

% set post activation threshholds
params.postact = set_postact(gpu);

%% ----------------- script to calculate intermediate params-----------------
calcparams

%% ---------------- make test summary ------------
params.testid = maketestid(params, network);

%% execute
fprintf('\n--- Feature extraction and classification (Hollywood2) ---\n')
% test_features_s2isa(network, params)

initializerandomseeds;

% %%-------------- compute descriptors for training data-------------
% if(params.num_movies<900)
%     [all_train_labels, all_test_labels, all_train_files, all_test_files] ...
%         = get_data_summary(params.infopath, params.num_movies);
% else
%     [all_train_labels, all_test_labels, all_train_files, all_test_files] ...
%         = get_data_summary(params.infopath);
% end

if params.feature.num_layers >= 2
    assert(size(network.isa{2}.H,2) == size(network.isa{2}.W,1));
end

% % print_network(network);
% % print_network(params);
% 
% for j = 1:params.num_km_init
%     train_label_all{j} = cell(1);
%     test_label_all{j} = cell(1);
% end

%%---------------TRAIN: compute raw features ---------------
all_train_files=[];
all_test_files=[];
all_train_labels=[];
all_test_labels=[];

fprintf('Computing features for all videos in the training set:\n');
[Xtrain_raw{1}, MM_train{1}, train_indices{1}, tr_names, lbss] = compute_raw_features_s2isa_hj(network, params, all_train_files, 1,batchz, MTY, tridx, -1);
fprintf('feature size: %d\n', size(Xtrain_raw{1}, 2));

%%---------------KMEANS: over all scales raw features ---------------
fprintf('Start vector quantization on training samples:\n');
[train_label_all, center_all, km_obj] = kmeans_stackisa(Xtrain_raw, params);    
clear Xtrain_raw

%%--------------TEST: compute raw features ---------------
fprintf('Computing features for all videos in the training set:\n');
[Xtest_raw{1}, MM_test{1}, test_indices{1}, test_names, lbss] = compute_raw_features_s2isa_hj(network, params, all_test_files, 1,batchz, MTY, teidx, -1);

%%-------------- assign test samples to the nearest centers------------
fprintf('assigning all labels to test data......\n')
for j = 1:params.num_km_init
    test_label_all{j}{1} = find_labels_dnc(center_all{j}, Xtest_raw{1});
end

clear Xtest_raw

%%-------------SAVE ------------
save_stackisa(params, center_all, km_obj, train_label_all, test_label_all, MM_train, MM_test, ...
        train_indices,test_indices,all_train_files,all_test_files,all_train_labels,all_test_labels);

% all_train_labels=-ones(all_train_labels,10);
% all_test_labels=-ones(all_test_labels,10);
all_train_files=train_indices;
all_test_files=test_indices;
% rerun_ap;

for ini_idx = 1:params.num_km_init

    fprintf('binning VQ labels.... \n')
    %%------------------ form svm inputs by binning ----------------------
%     Xtrain = formhist_stackisa(train_label_all, train_indices, params, MM_train, length(all_train_files), ini_idx);
    Xtrain = formhist_stackisa(train_label_all, train_indices, params, MM_train, length(all_train_files{1}), ini_idx);
    Xtest = formhist_stackisa(test_label_all, test_indices, params, MM_test, length(all_test_files{1}), ini_idx);

%     %%------------------ run SVM to classify data---------------------------
%     norm_type = params.norm_type;
%     unscramble = params.unscramble;    
%     [mean_ap_list(ini_idx), mean_acc_list(ini_idx)] = normalize_chi_svm_wangs(Xtrain, Xtest, norm_type, all_train_files, all_test_files, all_train_labels, all_test_labels, unscramble, params.infopath, 0);    

end

