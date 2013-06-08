
% build and test 1-NN classifier for characters

close all
clear all
clc

extractTrainingFeatures = 0;

letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

if(extractTrainingFeatures) % must extract training features 
    
    % create training set variables
    training_set = single(zeros(26*62,729)); % 27x27=729
    training_set_labels = zeros(26*62,1);

    % loop over the letters (26) and over the samples for each letter (62)
    % and represent each letter as a 729 long binary vector
    for i=1:26
        for j=1:62
            fprintf('%d %d\n',i,j);
            I = imread(sprintf('./trainingCharacterSet/%c%d.png',letters(i),j));
            I = single(im2bw(double(I)));
            training_set((i-1)*62+j,:) = I(:)';
            training_set_labels((i-1)*62+j) = i;
        end
    end

    % save training data
    save('training_set','training_set');
    save('training_set_labels','training_set_labels');

else

    % load training data
    load('training_set');
    load('training_set_labels');

end
     
% create and train a 1-NN classifier using Piotr Dollar's Matlab Toolbox
% funcitons
clf = clfKnn( 729, 1,'sqeuclidean' ); 

clf = clfKnnTrain( clf, training_set, uint8(training_set_labels) ) ;

save('characterClassifier','-struct','clf');
% clf = load('characterClassifier');


% extract test set features and ground truth labels
prototypes = single(zeros(200*12,729));
groundTruth_labels = zeros(200*12,1); 

for i=1:200 
    fid = fopen(sprintf('./TestImages/challenge%d/challenge%d.txt',i,i));
    while 1
        tline = fgetl(fid);
        if (~ischar(tline)) 
            break
        else 
            characters = tline ;
        end
    end
    fclose(fid);
    for j=1:12
        fprintf('%d %d\n',i,j);
        I = imread(sprintf('./TestImages/challenge%d/letter%d.png',i,j));
        I = single(ones(27,27) - im2bw(double(I))); 
        prototypes((i-1)*12+j,:) = I(:)';
        groundTruth_labels((i-1)*12+j) = find(letters == characters(j));
    end
end

prototype_labels = zeros(200*12,1); 

% apply classifier to test data
prototypes_labels = clfKnnFwd( clf, prototypes );

% evaluate performances
errors = find(groundTruth_labels ~= prototypes_labels); %
errorLetters = groundTruth_labels(errors);
for i=1:length(errorLetters)
    errorsTot(i) = letters(errorLetters(i));
end
errorsTot = errorsTot';

fprintf('\nCorrectly recognized characters: %d out of %d\n',(2400-length(errors)),2400);
fprintf('\nWrongly recognized characters: %d out of %d\n',length(errors),2400);
fprintf('\nError rate: %f\n',length(errors)/2400);


