function [mean_ap, mean_acc] = normalize_chi_svm_wangs(Xtrain, Xtest, norm_type,  ...
			   all_train_files, all_test_files, all_train_labels, all_test_labels, unscramble, infopath, num_subsamp_train)

% function to perform svm classification using Chi-squared kernel with pre-normalization
% includes uncrambling of indices on complete Hollywood2 dataset

%% requires: libsvm, chi folders (+computeAP)
% addpath /afs/cs/u/wzou/mf/
% addpath /afs/cs/u/wzou/mf/libsvm-mat-2.91-1/
% addpath /afs/cs/u/wzou/mf/chi/
% addpath /afs/cs/u/wzou/mf/chi/pwmetric/

%% sort filenames and labels
if(unscramble)
    fprintf('unscrambling data.....\n');
    [sorted_train_files, sort_train_idx]=sort(all_train_files);
    [sorted_test_files, sort_test_idx]=sort(all_test_files);
    
    sorted_Xtrain = Xtrain(sort_train_idx,:);
    sorted_Xtest = Xtest(sort_test_idx, :);
    
    %hard code for hw
    num_mv_train = 823;
    num_mv_test = 884;
    
    Xtrain_new = zeros(num_mv_train,size(Xtrain,2));
    Xtest_new = zeros(num_mv_test,size(Xtest,2));
    Xtrain_new(1,:) = sorted_Xtrain(1, :);
    Xtest_new(1,:) = sorted_Xtest(1, :);
    
    counter = 1;
    for i = 2:length(sorted_train_files)
        if strcmp(sorted_train_files(i), sorted_train_files(i-1)) == 0
            counter= counter +1;
            Xtrain_new(counter,:) = sorted_Xtrain(i, :);
        end
    end
    
    %assert(counter == num_mv_train);
    
    counter = 1;
    for i = 2:length(sorted_test_files)
        if strcmp(sorted_test_files(i), sorted_test_files(i-1)) == 0
            counter= counter +1;
            Xtest_new(counter,:) = sorted_Xtest(i, :);
        end
    end
    
    %assert(counter == num_mv_test);    
else
    Xtrain_new = Xtrain;
    Xtest_new = Xtest;
end
%% normalize Xtrain and Xtest

fprintf('normalizing.....\n');
Xtrain = zeros(size(Xtrain_new));

for i = 1:size(Xtrain,1)
    n = norm(Xtrain_new(i,:), norm_type);
    if ~(n==0)
        Xtrain(i,:) = Xtrain_new(i, :)/n;
    end
end

Xtest = zeros(size(Xtest_new));

for i = 1:size(Xtest,1)
    n = norm(Xtest_new(i, :), norm_type);
    if ~(n==0)
        Xtest(i,:) = Xtest_new(i, :)/n;
    end
end

%%

%% load labels, run svm

actions = textread([infopath, 'classes.txt'], '%s\n');
l = length(actions);

%%------------------ subsample training data ---------------------------

if num_subsamp_train
    rndidx = randperm(size(Xtrain, 1));
    filter = rndidx(1:num_subsamp_train);
    Xtrain = Xtrain(filter, :);
end

%%------------------ run SVM to classify data---------------------------
 
fprintf('start classfication with chi-squared kernel svm, computing kernel matrices......\n');

[Ktrain, Ktest] = compute_kernel_matrices(Xtrain, Xtest);

counter = 0;
average_ap = 0;
average_acc = 0;

for label=1:l    

    if unscramble
        action = actions{label};
        [~, train_labels] = textread([infopath, action, '_train.txt'], '%s\t%f\n');
        [~, test_labels]   = textread([infopath, action, '_test.txt'],  '%s\t%f\n');
        
        if num_subsamp_train
            train_labels = train_labels(filter);
        end
        
        Ytrain_new = double(train_labels>0);
        Ytest_new = double(test_labels>0);
    else
        Ytrain_new = double(all_train_labels == label);
        Ytest_new = double(all_test_labels == label);
    end
    
    n_total = length(Ytrain_new);
    n_pos = sum(Ytrain_new);
    n_neg = n_total-n_pos;
    
    cost = 100; % chosen as fixed: on personal communication with Wang et. al [42] paper citation
    
    % positive and negative weights balanced with number of positive and
    % negative examples
    % on personal communication with Wang et. al [42] paper citation
    w_pos = n_total/(2*n_pos);
    w_neg = n_total/(2*n_neg);
    
    option_string = sprintf('-t 4 -q -s 0 -b 1 -c %f -w1 %f -w0 %f',cost, w_pos, w_neg);

    model = svmtrain(Ytrain_new, Ktrain, option_string);
    
    [~, accuracy,prob_estimates] = svmpredict(Ytest_new, Ktest, model, '-b 1');
    
    [ap,~,~] = computeAP(prob_estimates(:,model.Label==1), Ytest_new, 1, 0, 0);
        
    average_ap = average_ap + ap;
    average_acc = average_acc + accuracy(1);
    counter = counter + 1;
    
    fprintf('label = %d,ap = %f, w_neg = %f, w_pos = %f\n', label,  ap, w_neg, w_pos);    
end
mean_ap = average_ap / l;
mean_acc = average_acc / l;
fprintf('mean_ap = %f, mean_acc = %f\n', mean_ap, mean_acc);

