% -o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-
%
%                               SAMPLE CODE FOR THE
%                    ONE-SHOT-LEARNING CHALEARN GESTURE CHALLENGE
%    
%                             ROUND 2 version -- June 2012
%                                   
% -o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-
%
% DISCLAIMER: ALL INFORMATION, SOFTWARE, DOCUMENTATION, AND DATA ARE PROVIDED "AS-IS" 
% ISABELLE GUYON AND/OR OTHER CONTRIBUTORS DISCLAIM ANY EXPRESSED OR IMPLIED WARRANTIES, 
% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
% FOR ANY PARTICULAR PURPOSE, AND THE WARRANTY OF NON-INFRIGEMENT OF ANY THIRD PARTY'S 
% INTELLECTUAL PROPERTY RIGHTS. IN NO EVENT SHALL ISABELLE GUYON AND/OR OTHER CONTRIBUTORS 
% BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER
% ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF SOFTWARE, DOCUMENTS, 
% MATERIALS, PUBLICATIONS, OR INFORMATION MADE AVAILABLE FOR THE CHALLENGE. 

%% Initialization
clear classes
close all
this_dir=pwd;

% -o-|-o-|-o-|-o-|-o-|-o-|-o- BEGIN USER-PREFERENCES -o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-

% 1) User-defined directories (no slash at the end of the names):
% --------------------------------------------------------------
% The present set up supposes that you are now in the directory Sample_code
% and you have the following directory tree, where Challenge is you project directory:
% Challenge/Data
% Challenge/Results
% Challenge/Sample_code

my_name     = 'Ying Yin';     % Your name or nickname
my_root     = this_dir(1:end-12);   % Change that to the directory of your project

data_dir    = [my_root '/Data'];    % Path to the data.
resu_dir    = [my_root '/Results']; % Where the results will end up.  
truth_dir   = [];                   % Where the missing truth labels are...
code_dir    = [my_root '/Sample_code']; 
                                    

% 2) Choose your data batches
% ---------------------------
type ={'devel', 'valid'}; % Add 'final' when you get the final evaluation sets
                          % Note: for round 2 new final sets numbered 21-40
                          % will be provided. Use num=1:20 anyways because
                          % we add 20 to the counter for round 2 in the code
                          
num=1:20;

% 3) Choose your recognizer
% -------------------------
recognizer_list={@basic_recog, @principal_motion, @dtw};
reco_num=1; % 1 for basic_recog, 2 for principal_motion, etc.

% 3) Enable debug mode
% --------------------
debug=0;

% -o-|-o-|-o-|-o-|-o-|-o-|-o- END USER-PREFERENCES -o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-

% Set the path and defaults properly; create directories; enable debug mode
% -------------------------------------------------------------------------
warning off; 
addpath(genpath(code_dir)); 
warning on;

makedir(resu_dir);

if debug
    dbstop if error
else
    %dbclear if error
end
% Remove spaces
my_name(my_name==' ')='';

% Advanced: recognizer options
recog_options={'test_on_training_data=1', 'movie_type=''K'''};
% If test_on_training_data=0, the training examples are not tested with the
% model and the prediction values for training examples are the truth
% values of the labels.
% There are 2 options for movie_type: 'K' (depth image) and 'M' (RGB
% image). This is the type of movie used by the recognizer.
if debug
    recog_options =[recog_options 'verbosity=1'];
end

% Challenge round number
round=2;

%% Train/Test
% LOOP OVER BATCHES 
% =================

starting_time=datestr(now, 'yyyy_mm_dd_HH_MM');

fprintf('\n-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-\n');
fprintf('\n-o-|-o-|-o-|     EXPERIMENT  %s      |-o-|-o-|-o-\n', starting_time);
fprintf('\n-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-\n\n');

fprintf('== Legend ==\n');
fprintf('Rand --\t\t\t Score for random substitutions\n\t\t\t (no insertion or deletions).\n');
fprintf('TrLev and TeLev --\t Training and test scores\n\t\t\t (sum Levenshtein distances / true number of gestures).\n');
fprintf('TrLen and TeLen--\t Ave. error made on the number of gestures.\n');
fprintf('Time--\t\t\t Time to train a model and test it on the batch.\n');
fprintf('Average--\t\t Weighted average of scores of the batch,\n\t\t\t weighted by the number of gestures in the set.\n');

for k=1:length(type)
    fprintf('\n==========================================\n');
    fprintf('============    %s DATA', upper(type{k}));
    if strcmp(type{k}, 'final') && round==2, num=num+20; fprintf('%d', round); else fprintf(' '); end
    fprintf('   ============\n==========================================\n');
        
    have_truth=(strcmp(type{k}, 'devel') || ~isempty(truth_dir));   
    if have_truth
        fprintf('SetName\tRand%%\tTrLev%%\tTrLen%%\tTeLev%%\tTeLen%%\tTime(s)\n');
    else
        fprintf('SetName\tRand%%\tTrLev%%\tTrLen%%\tTime(s)\n');
    end
    
    N=length(num);                  % Number of batches
    RandScore=zeros(N, 1);          % Score for random substitutions (no insertion or deletions)
    TrLevenScore=zeros(N, 1);       % Training score (sum Levenshtein distances / true number of gestures)
    TrLengthScore=zeros(N, 1);      % Average error made in estimating the number of gestures (for training examples)
    TrLabelNum=zeros(N, 1);         % Number of training gestures
    TeLevenScore=zeros(N, 1);       % Test score (sum Levenshtein distances / true number of gestures)
    TeLengthScore=zeros(N, 1);      % Average error made in estimating the number of gestures (for test examples)
    TeLabelNum=zeros(N, 1);         % Number of test gestures
    Time=zeros(N, 1);               % Time to train and test the batch

    for i=1:N

        set_name=sprintf('%s%02d', type{k}, num(i));
        fprintf('%s\t', set_name);
    
        % Load training and test data
        dt=sprintf('%s/%s', data_dir, set_name);
        if ~exist(dt),fprintf('No data for %s\n', set_name); continue; end
        D=databatch(dt, truth_dir);

        % Uncomment this to browse the data
        % browser('D'); 
        
        % Split the data into training and test set
        Dtr=subset(D, 1:D.vocabulary_size);
        Dte=subset(D, D.vocabulary_size+1:length(D));
        TrLabelNum(i)=labelnum(Dtr);
        TeLabelNum(i)=labelnum(Dte);

        % Baseline: error rate for random substitutions
        RandScore(i)=(1-1/D.vocabulary_size);
        fprintf('%5.2f\t', 100*RandScore(i));
        
        % Train a recognizer
        mymodel=recognizer_list{reco_num};
        tic
        [tr_resu, mymodel]=train(mymodel(recog_options), Dtr);
        TrLevenScore(i)=leven_score(tr_resu);
        TrLengthScore(i)=length_score(tr_resu);
        fprintf('%5.2f\t%5.2f\t', 100*TrLevenScore(i), ...
                                  100*TrLengthScore(i));
        
        % Uncomment this to visualize the model templates
        % show(mymodel);
        
        % Test the model
        te_resu=test(mymodel, Dte);
        Time(i)=toc;
        
        % Compute the test scores
        if have_truth % We know the test labels
            TeLevenScore(i)=leven_score(te_resu);
            TeLengthScore(i)=length_score(te_resu);
            fprintf('%5.2f\t%5.2f\t', 100*TeLevenScore(i), ...
                                      100*TeLengthScore(i));
        end
        fprintf('%5.2f\n', Time(i));
        
        % Save the results for validation and final data (with the training
        % scores, this is optional)
        if ~strcmp(type{k}, 'devel')
            save(tr_resu, [resu_dir '/' set_name '_predict.csv'], [set_name '_'], 'w');
            save(te_resu, [resu_dir '/' set_name '_predict.csv'], [set_name '_'], 'a');
        end
    end    
    
    % Summary of results (we need to do a weighted average to get the same
    % result as what we get when we concatenate all the result files)
    if ~isempty(TeLevenScore)
        fprintf('Average\t%5.2f\t%5.2f\t%5.2f\t%5.2f\t%5.2f\t%5.2f\n', ...
                                      100*mean(RandScore), ...
                                      100*average(TrLevenScore, TrLabelNum), ...
                                      100*average(TrLengthScore, TrLabelNum));
        if have_truth
            fprintf('%5.2f\t%5.2f\t', 100*average(TeLevenScore, TeLabelNum), ...
                                      100*average(TeLengthScore, TeLabelNum));
        end                        
        fprintf('%5.2f\t%5.2f\n', mean(Time));      
    end
    fprintf('\n');
end

% Prepare the submission by concatenating the results
predict_file=[class(mymodel) '_' my_name '_' starting_time '_predict.csv'];
prepare4submit(predict_file, resu_dir);

% Score the overall results
if ~isempty(truth_dir)
    [test_valid_score, test_final_score, train_valid_score, train_final_score] = ...
        compare_files([truth_dir '/truth.csv'], [resu_dir '/' predict_file], round);
    fprintf('\n\n== Summary of results for model %s ==\n', class(mymodel));
    fprintf('\nOverall validation error (0 is best): Train=%5.2f%% Test=%5.2f%%\n', 100*train_valid_score, 100*test_valid_score);
    fprintf('Overall final evaluation error (0 is best): Train=%5.2f%% Test=%5.2f%%\n', 100*train_final_score, 100*test_final_score);
end

