function [all_train_labels, all_test_labels, all_train_files, all_test_files] = get_data_summary(info_path, num_movies)
%[all_train_labels, all_test_labels, all_train_files, all_test_files] =
%                   get_data_summary(file_path, num_movies)
% INFO_PATH : path to video information (ClipSets)
% NUM_MOVIES: number of movies for processing
% ALL_TRAIN_LABELS : train labels
% ALL_TEST_LABELS  : test labels
% ALL_TRAIN_FILES  : train file names
% ALL_TEST_FILES   : test file names
% test file, train file and labels are organized such that each index will
% give the filename and corresponding labels

%% customized for different datasets; this is for Hollywood2
    actions = {'AnswerPhone', 'DriveCar', 'Eat', 'FightPerson', ...
        'GetOutCar', 'HandShake', 'HugPerson', 'Kiss','Run', ...
        'SitDown', 'SitUp', 'StandUp'};

%% The following code extracts each movie-label pair in a list from
%% ClipSets, which contains, for each action label, a file giving binary
%% indication of whether each clip has that action label
%since a single movie may have multiple labels, the list is longer than
%total number of movie clips; during classification the list is unscrambled
%to comply with correct testing procedures

l = length(actions);
all_train_files = {};
all_test_files = {};
all_train_labels = [];
all_test_labels = [];
for i=1:l
    action = actions{i};
    
    [train_files, train_labels] = textread([info_path, action, '_train.txt'],'%s\t%f\n');
    [test_files, test_labels] = textread([info_path, action, '_test.txt'],'%s\t%f\n');
    
    positive_train_labels = train_labels >= 1;
    positive_test_labels = test_labels >= 1;
    all_train_labels = [all_train_labels;  i*ones(sum(positive_train_labels),1)];
    all_test_labels = [all_test_labels;  i*ones(sum(positive_test_labels),1)];
    all_train_files = [all_train_files;  train_files(positive_train_labels)];
    all_test_files = [all_test_files; test_files(positive_test_labels)];
end

if exist('num_movies', 'var')&&(num_movies>0)    
    m = length(all_train_files);
    p = randperm(m);
    p = p(1:num_movies); % if no input, take all movies
    all_train_labels = all_train_labels(p,:);
    all_train_files = all_train_files(p,:);
    
    all_test_labels = all_test_labels(p,:);
    all_test_files = all_test_files(p,:);    
end
