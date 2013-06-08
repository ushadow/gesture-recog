function [test_valid_score, test_final_score, train_valid_score, train_final_score]=compare_files(truth_file, predict_file, round)
%[test_valid_score, test_final_score, train_valid_score, train_final_score]=compare_files(truth_file, predict_file)
% Compare a truth value file and a prediction file.
% Returns the score s that is the sum of edit distances between
% truth labels and predictions in every line of the files.
% THIS IS NOT A SYMMETRIC FUNCTION.
% The truth file must come first. We use it to determine
% the number of training examples (number of unique
% label values).

% Isabelle Guyon -- October 2011-May 2012 -- isabelle@clopinet.com

if nargin<3, round=1; end

debug=0;

% Load the predicted values
[predict_labels, predict_samples]=read_file(predict_file);

train_valid_score=NaN;
train_final_score=NaN;

% simple sanity checks
if ~sanity(predict_samples)
    test_valid_score=NaN;
    test_final_score=NaN;
    return
end

% Load the truth values
[truth_labels, truth_samples]=read_file(truth_file);
[train_labels, train_samples, test_labels, test_samples]=split_train_test(truth_labels, truth_samples);

% Create associative arrays
predicted=cell(1,max(truth_samples));
predicted(predict_samples)=predict_labels;
train_truth(train_samples)=train_labels;
test_truth(test_samples)=test_labels;

% First digit indicates the data type 1=valid, 2=final, 3=verif, 4=devel
idx_train_valid=find(train_samples<20000);
idx_test_valid=find(test_samples<20000);
if round==1
    idx_train_final=find(train_samples>=20000 & train_samples<22100);
    idx_test_final=find(test_samples>=20000 & test_samples<22100); % we take only round 1
else
    idx_train_final=find(train_samples>=22100 & train_samples<30000);
    idx_test_final=find(test_samples>=22100 & test_samples<30000); % we take only round 2
end

% Check the training examples
idx=train_samples(idx_train_valid);
p=predicted(idx);
if isempty([p{:}]) && debug
    fprintf('Warning: no validation training example\n');
else
    train_valid_score=lscore(train_truth(idx), predicted(idx));
    if train_valid_score~=0 && debug
        fprintf('Warning: validation training score not zero\n');
    end
end

idx=train_samples(idx_train_final);
p=predicted(idx);
if isempty([p{:}]) && debug
    fprintf('Warning: no final training example\n');
else
    train_final_score=lscore(train_truth(idx), predicted(idx));
    if train_final_score~=0 && debug
        fprintf('Warning: final training score not zero\n');
    end
end
% Now the test examples
idx=test_samples(idx_test_valid);
[test_valid_score, lsc]=lscore(test_truth(idx), predicted(idx));
if debug
    types={'valid', 'final', 'verif'};
    fp=fopen([predict_file '.log'], 'w');
    for k=1:length(idx)
        [type,set,num]=split_id(idx(k));
        fprintf(fp, '%s%02d_%d,%d\n', types{type}, set, num, lsc(k));
        if lsc(k)~=0
            fprintf('%s%02d_%d,%d ==> ', types{type}, set, num, lsc(k));
            t=test_truth{idx(k)};
            p=predicted{idx(k)};
            for kk=1:length(p)
                fprintf('%d ', p(kk));
            end
            fprintf( '--- ');
            for kk=1:length(t)
                fprintf('%d ', t(kk));
            end  
            fprintf('\n');
        end
    end
end

if debug,
    fprintf('\n=======\n\n');
end

idx=test_samples(idx_test_final);
[test_final_score, lsc]=lscore(test_truth(idx), predicted(idx));
if debug
    for k=1:length(idx)
        [type,set,num]=split_id(idx(k));
        fprintf(fp, '%s%02d_%d,%d\n', types{type}, set, num, lsc(k));
        if lsc(k)~=0
            fprintf('%s%02d_%d,%d ==> ', types{type}, set, num, lsc(k));
            t=test_truth{idx(k)};
            p=predicted{idx(k)};
            for kk=1:length(p)
                fprintf('%d ', p(kk));
            end
            fprintf( '--- ');
            for kk=1:length(t)
                fprintf('%d ', t(kk));
            end  
            fprintf('\n');
        end
    end
    fclose(fp);
end

fclose all