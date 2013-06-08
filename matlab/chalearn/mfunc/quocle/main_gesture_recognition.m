clear all; close all, clc;
 
cd C:\GestureRecognitionChallenge\Challenge\3\Sample_code\release\


tsegpath='C:\GestureRecognitionChallenge\Challenge\3\Tempo_segment\tempo_segment\';
clop_model=svm;
MTY='M';
batchz='devel03';

datapath=['C:\GestureRecognitionChallenge\Challenge\Data\' batchz '\'];

% % % % Extracts deep learning features to be used for gesture recognition
master_train_hj_perbatch(datapath, pwd, MTY);

% % % % Extract features for training and test frames within a batch
path = './'; %current folder

% ***CHANGE TO DESIRED PATHS***
% batchz='devel';
% 
% tridx=1:2;
% teidx=3:4;
params.afspath = 'C:\GestureRecognitionChallenge\Challenge\3\Sample_code\';
params.savepath = 'C:\GestureRecognitionChallenge\Challenge\3\Sample_code\'; %path to save intermediate (before svm classification) results
% params.jacketenginepath = '/**/jacket/engine/'; % option to use Jacket GPU code for MATLAB http://www.accelereyes.com/

% option: dense sampling parameter
dense_p = 2;
% 1 for non-overlap grid sampling of features
% 2 for 50% overlap grid sampling of features
%%

% option: use GPU with Jacket 
gpu = 0;
%%

%DEFAULT SET UP FOR HOLLYWOOD2

% addpath(path);
% addpath([path, '/activation_functions/']);
% addpath([path, '/mmread/']);
% addpath([path, '/tbox/']);
% addpath([path, '/svm/']);
% addpath([path, '/svm/chi/']);
% addpath([path, '/svm/chi/pwmetric/']);
% addpath([path, '/svm/libsvm-mat-3.0-1/']);
% 
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
params.infopath = [params.afspath, 'ClipSets/']; %path for video labels/info
params.infopath = '';

%number of supervised train & test movies (for controlled testing)
params.num_movies = 1000; %anything >900 = train/test all movies

%vector quantization
% params.num_centroids = 3000; %for kmeans feature aggregation: recommend 1e4 centroids when using linear kernel, 3000 centroids when using chi-squared kernel
% params.num_km_init = 3; %number of random kmeans initializations
% params.num_km_samples = 1000; %number of kmeans samples *Per Centroid*
% params.seed = 10; %random seed for kmeans

params.num_centroids = 300; %for kmeans feature aggregation: recommend 1e4 centroids when using linear kernel, 3000 centroids when using chi-squared kernel
params.num_km_init = 10; %number of random kmeans initializations
params.num_km_samples = 10; %number of kmeans samples *Per Centroid*
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
fprintf('\n--- Feature extraction and classification batch \n')
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
% all_train_files=[];
% all_test_files=[];
all_train_labels=[];
all_test_labels=[];



XD=importdata([datapath batchz '_train.csv']);
for i=1:length(XD.rowheaders),
    all_train_files{i}=[strrep(XD.rowheaders{i}, [batchz '_'], [MTY '_']) '.avi'];
%     naix=find(~isnan(XD.data(i,:)));
%     lbss{i}=(XD.data(i,naix));
end
lbss=read_file([datapath batchz '_train.csv']);
for i=1:length(lbss),
    Ytrain(i,1)=lbss{i};
end
classex=union(Ytrain,Ytrain);
n_classex=length(classex);
Ytrain_ones=-ones(size(Ytrain,1),n_classex);
for i=1:size(Ytrain_ones,1),
    Ytrain_ones(i,Ytrain(i))=1;
end

% XT=importdata([datapath batchz '_test.csv']);
[labelsT, samplesT]=read_file([datapath batchz '_test.csv'], 0);
for i=1:length(samplesT),
    cad=num2str(samplesT(i));
    all_test_files{i}=[MTY '_' num2str(str2num(cad(4:5))) '.avi'];
%     [strrep(XT.rowheaders{i}, [batchz '_'], [MTY '_']) '.avi'];
%     idx=strfind(all_test_files{dc},',');    
%         if ~isempty(idx),           
%             all_test_files{dc}=[all_test_files{dc}(1:idx-1) '.avi'];        
%         end    
        
%         dc=dc+1;
end
% dc=1;
% for i=1:length(XT.rowheaders),
%     if (strfind(XT.rowheaders{i},batchz)),
%         all_test_files{dc}=[strrep(XT.rowheaders{i}, [batchz '_'], [MTY '_']) '.avi'];
%         idx=strfind(all_test_files{dc},',');    
%         if ~isempty(idx),           
%             all_test_files{dc}=[all_test_files{dc}(1:idx-1) '.avi'];        
%         end    
%         
%         dc=dc+1;
%     end
% end
lbss_T=read_file([datapath batchz '_test.csv']);
eval(['load ' tsegpath batchz '.mat;']);
fprintf('Computing features for all videos in the training set:\n');
[Xtrain_raw{1}, MM_train{1}, train_indices{1}, tr_names, lbss] = compute_raw_features_s2isa_hj_perbatch(network, params, all_train_files, 1,batchz, MTY, saved_annotation(1:length(all_train_files)));
fprintf('feature size: %d\n', size(Xtrain_raw{1}, 2));

%%---------------KMEANS: over all scales raw features ---------------
fprintf('Start vector quantization on training samples:\n');
[train_label_all, center_all, km_obj] = kmeans_stackisa(Xtrain_raw, params);    
% clear Xtrain_raw



tsegT=saved_annotation(length(all_train_files)+1:end);
dc=1;
for i=1:length(all_test_files),
    for j=1:length(lbss_T{i}),
        all_test_files_art{dc}=all_test_files{i};
        lbss_T_art{dc}=lbss_T{i}(j);        
        if (isempty(tsegT{i}))
            tsegT_art{dc}=[1,2];
        else
            tsegT_art{dc}=tsegT{i}(j,:);            
        end
        dc=dc+1;
    end
end
Ytest_ones=-ones(length(lbss_T_art),n_classex);    
for i=1:length(lbss_T_art),
    Ytest_art(i,1)=lbss_T_art{i};
    Ytest_ones(i,Ytest_art(i))=1;
end

%%--------------TEST: compute raw features ---------------
fprintf('Computing features for all videos in the testing set:\n');
[Xtest_raw{1}, MM_test{1}, test_indices{1}, test_names, lbss] = compute_raw_features_s2isa_hj_perbatch(network, params, all_test_files_art, 1,batchz, MTY, tsegT_art);

%%-------------- assign test samples to the nearest centers------------
fprintf('assigning all labels to test data......\n')
for j = 1:params.num_km_init
    test_label_all{j}{1} = find_labels_dnc(center_all{j}, Xtest_raw{1});
end

% clear Xtest_raw

%%-------------SAVE ------------
save_stackisa(params, center_all, km_obj, train_label_all, test_label_all, MM_train, MM_test, ...
        train_indices,test_indices,all_train_files,all_test_files,all_train_labels,all_test_labels);


% % % % % Classifiers at the bag-of-visual-words level    
for ini_idx = 1:params.num_km_init

    fprintf('binning VQ labels.... \n')
    %%------------------ form svm inputs by binning ----------------------
%     Xtrain = formhist_stackisa(train_label_all, train_indices, params, MM_train, length(all_train_files), ini_idx);
    Xtrain = formhist_stackisa(train_label_all, train_indices, params, MM_train, length(all_train_files), ini_idx);
    Xtest = formhist_stackisa(test_label_all, test_indices, params, MM_test, length(all_test_files_art), ini_idx);

    
    
%     % % % % % %  classification approach from Quoc's paper
% % %     %%------------------ run SVM to classify data---------------------------
%     norm_type = params.norm_type;
%     unscramble = params.unscramble;    
% 
%     for i = 1:size(Xtrain,1)
%         n = norm(Xtrain(i,:), norm_type);
%         if ~(n==0)
%             Xtrain(i,:) = Xtrain(i, :)/n;
%         end
%     end
% 
% %     Xtest = zeros(size(Xtest ));
% 
%     for i = 1:size(Xtest,1)
%         n = norm(Xtest (i, :), norm_type);
%         if ~(n==0)
%             Xtest(i,:) = Xtest (i, :)/n;
%         end
%     end

%     [Ktrain, Ktest] = compute_kernel_matrices(Xtrain, Xtest);
%     
%     
%     [a,b]=train(one_vs_rest(svm(kernel({'custom',Ktrain(:,2:end)}))),data(Xtrain,Ytrain_ones));
%      for ii=1:length(b.child),
% %             b.child{ii}.dat=Ktest(:,2:end);
%             b.child{ii}.child=kernel({'custom',Ktest(:,2:end)'});
%         end
%     [c]=test(b,data(Xtest,Ytest_ones));
%     for i=1:size(Ytest_ones,1)
%         Ypred(i)=find(c.X(i,:)==1);
%     end
%     erx=Ypred'-Ytest_art;
%     maccu(ini_idx)=(length(find(erx==0))./length(erx)).*100;
    
    
    
% % % % % % Multiclass SVM classifier from spider
% %     [a,b]=train(mc_svm(kernel('rbf',2)),d)
%         [a,b]=train(mc_svm,data(Xtrain,Ytrain_ones));
% %         [c]=test(b,data(Xtest,Ytest_ones));
%         [c]=test(b,data(Xtest,Ytest_ones));
%         for i=1:size(Ytest_ones,1)
%             Ypred(i)=find(c.X(i,:)==1);
%         end
%         erx=Ypred-Ytest_art;
%         maccu(ini_idx)=(length(find(erx==0))./length(erx)).*100;

 
% % % % % % % % Multiclass classification with one-vs-one and one-vs-rest spider
        [a,b]=train(one_vs_rest(clop_model),data(Xtrain,Ytrain_ones));
%         [a,b]=train(one_vs_rest(svm(kernel({'custom',Ktrain(:,2:end)}))),data(Xtrain,Ytrain_ones));
%         for ii=1:length(b.child),
%             b.child{ii}.dat=Ktest(:,2:end);
%         end
%     [a,b]=train(one_vs_one(clop_model),data(Xtrain,Ytrain_ones));
    [c]=test(b,data(Xtest,Ytest_ones));
  for i=1:size(Ytest_ones,1)
        Ypred(i)=find(c.X(i,:)==1);
    end
    erx=Ypred'-Ytest_art;
    maccu(ini_idx)=(length(find(erx==0))./length(erx)).*100;
    enspred(:,ini_idx)=Ypred';



% % % % % Own implementation of one-vs-rest classifier
%     for i=1:n_classex,
%         bino=-ones(size(Ytrain));
%         bino(find(Ytrain==classex(i)))=1;
%         bano=-ones(size(Ytest_art));
%         bano(find(Ytest_art==classex(i)))=1;
%         [a,b]=train(clop_model,data(Xtrain,bino));
%         [c]=test(b,data(Xtest,bano));
%         
%         mclass(:,i)=c.X;        
%         mclassn(:,i)=(mclass(:,i)-min(mclass(:,i)))./(max(mclass(:,i))-min(mclass(:,i)));
%     end
%     [a,b]=sort(mclass,2,'descend');
%     Ypred=b(:,1);
%     [a,b]=sort(mclassn,2,'descend');
%     Ypredn=b(:,1);
%     
%     erx=classex(Ypred)-Ytest_art;
%     maccu(ini_idx)=(length(find(erx==0))./length(erx)).*100;
%     erx=classex(Ypredn)-Ytest_art;
%     maccun(ini_idx)=(length(find(erx==0))./length(erx)).*100;
%     
% %     [mean_ap_list(ini_idx), mean_acc_list(ini_idx)] = normalize_chi_svm_wangs(Xtrain, Xtest, norm_type, all_train_files, all_test_files, all_train_labels, all_test_labels, unscramble, params.infopath, 0);    


prediction=Ypred;
% fname=['pred_DLFs_'strrep(strrep(datestr(now),':','') '.csv'],' ','');
% fid=fopen(fname,'w');
for i=1:length(all_test_files),
    [a,b]=ismember(all_test_files_art,all_test_files{i});
    pridx=find(b);
    preCell(i)={[prediction(pridx)]};
    trhupre(i)={[Ytest_art(pridx)']};    
    
%     an=[all_test_files{i} ','];
%     for j=1:length(b),
%         an=[an '' prediction()]
%     end
%     fprintf(fid,)
end
[score(ini_idx), local_scores]=lscore(trhupre,preCell);
% fclose(fid);
% [score, local_scores]=lscore(truth, pred)
% % q = levenshtein(s1,s2)

clear preCell trhupre;
end

prediction=mode(enspred,2);

for i=1:length(all_test_files),
    [a,b]=ismember(all_test_files_art,all_test_files{i});
    pridx=find(b);
    preCell(i)={[prediction(pridx)]};
    trhupre(i)={[Ytest_art(pridx)']};    
%     an=[all_test_files{i} ','];
%     for j=1:length(b),
%         an=[an '' prediction()]
%     end
%     fprintf(fid,)
end
[scoreab, local_scores]=lscore(trhupre,preCell);

erx=prediction-Ytest_art;
maccug=(length(find(erx==0))./length(erx)).*100;

 % maccu

% % % % % % % Classifiers at the feature level
% Xtrain=[];
% Ytrainraw=[];
% feats=[101:200];
% for i=1:length(train_indices{1}),
%     Xtrain=[Xtrain;Xtrain_raw{1}(train_indices{1}{i}.start:train_indices{1}{i}.end,feats)];
%     Ytrainraw=[Ytrainraw;Ytrain(i).*ones(size(Xtrain_raw{1}(train_indices{1}{i}.start:train_indices{1}{i}.end,:),1),1)];
% end
% 
% Ytrain_ones_raw=-ones(size(Ytrainraw,1),n_classex);
% for i=1:size(Ytrain_ones_raw,1),
%     Ytrain_ones_raw(i,Ytrainraw(i))=1;
% end
% 
% 
% 
% 
% Xtest=[];
% Ytestraw=[];
% 
% for i=1:length(test_indices{1}),
%     Xtest=[Xtest;Xtest_raw{1}(test_indices{1}{i}.start:test_indices{1}{i}.end,feats)];
%     Ytestraw=[Ytestraw;Ytest_art(i).*ones(size(Xtest_raw{1}(test_indices{1}{i}.start:test_indices{1}{i}.end,:),1),1)];
% end
% 
% Ytest_ones_raw=-ones(size(Ytestraw,1),n_classex);
% for i=1:size(Ytest_ones_raw,1),
%     Ytest_ones_raw(i,Ytestraw(i))=1;
% end
% 
% [a,b]=train(one_vs_rest(clop_model),data(Xtrain,Ytrain_ones_raw));
% %     [a,b]=train(one_vs_one(clop_model),data(Xtrain,Ytrain_ones));
% [c]=test(b,data(Xtest,Ytest_ones_raw));
% for i=1:size(Ytest_ones_raw,1)
%     Ypred_raw(i)=find(c.X(i,:)==1);
% end
% erx=Ypred_raw'-Ytestraw;
% maccu_raw=(length(find(erx==0))./length(erx)).*100;
% 

% % % % % % generate a file with predictions
% prediction=Ypred;
% fname=['pred_DLFs_'strrep(strrep(datestr(now),':','') '.csv'],' ','');
% fid=fopen(fname,'w');
% for i=1:length(all_test_files),
%     [a,b]=ismember(all_test_files{i},all_test_files_art);
%     an=[all_test_files{i} ','];
%     for j=1:length(b),
%         an=[an '' prediction()]
%     end
%     fprintf(fid,)
% end
% fclose(fid);
% [score, local_scores]=lscore(truth, pred)
% % q = levenshtein(s1,s2)