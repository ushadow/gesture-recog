% apply the classifiers to the test data


clear all
clc

featureTypes = {'edgeHistogramFeatures','colorMomentFeatures' ,  'gistFeatures' , 'colorHistogramFeatures'};
modelTypes = { 'edgeHistogram', 'colorMoment',  'gist' , 'colorHistogram'};

featureType =  featureTypes{1};
modelType = modelTypes{1};

indexFeatures = 50;

useKnn = 0;
k = 1;

% read categories names
letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
load concept
clf = load('characterClassifier');

for i=1:200
    i
    conceptsToFind = [];
    folder = sprintf('./TestImages/challenge%d',i);
    fid = fopen(sprintf('%s/challenge%d.txt',folder,i));
    for j=1:2
        tline = fgetl(fid);
    end
    for j=1:3
        tline = fgetl(fid);
        groundTruthCharacters(i,j) = tline(1);
        conceptsToFind{j} = tline(5:end);
    end
    for j=1:4
        tline = fgetl(fid);
    end
    for j=1:3
        groundTruthImages(i,j) = find(tline == groundTruthCharacters(i,j));
    end
    fclose(fid);
    
    % train a k-NN classifier on the 3 categories requested
    if(useKnn)
        training_set_labels = [];
        training_set = [];
        load(sprintf('%s/%s',folder,featureType));
        features = edgeHistogramFeatures; %
        
        for con=1:length(conceptsToFind)
            folder = sprintf('./trainingSet/%s',conceptsToFind{con});
            load(sprintf('%s/%s',folder,featureType));
            featuresTmp = edgeHistogramFeatures;
            featuresTmp(indexFeatures+1:end,:) = [];
            [featureHeight featureWidth] = size(features);
            training_set_labels =  ones(featureHeight,1)*con;
            training_set = edgeHistogramFeatures;
        
            clfK = clfKnn( featureWidth, k,'sqeuclidean' );
            clfK = clfKnnTrain( clfK, double(training_set), uint8(training_set_labels) ) ;
            D = pdist2( edgeHistogramFeatures, clfK.Xtrain, clfK.metric );
           % [predictions D] = clfKnnFwd( clfK, features );
            if(con>1)
                D(predictedImages(i,con-1),:) = 100;;
            end
            [minVal minPos] = min(min(D'));
            predictedImages(i,con) = minPos;
        end
        folder = sprintf('./TestImages/challenge%d',i);
    
    else

        % apply classifiers
        totPredicitons = [];
        for k=1:length(conceptsToFind)

            % predict image
            system(sprintf('svm-predict.exe -b 1 "%s/%s.txt" "./trainingSet/%s/%s.model" "%s/%sPredictions%d.txt" > r.txt',folder,featureType,conceptsToFind{k},modelType,folder,modelType,k));
            predictions = dlmread(sprintf('%s/%sPredictions%d.txt',folder,modelType,k),' ',1,1);
            totPredicitons = horzcat(totPredicitons,predictions(:,1));
        end
        [val preds] = max(totPredicitons);
        v = ones(1,length(val));
        if(length(unique(preds)) ~= length(preds))
            while(length(unique(preds)) ~= length(preds))
                [val2 pos] = max(val);
                totPredicitons(preds(pos),:) = 0;
                totPredicitons(preds(pos),pos) = 1;
                v(pos) = 0;
                [val preds] = max(totPredicitons);
                val = val.*v;
            end
        end
        predictedImages(i,:) = preds;

    end


    % predict character
    for k=1:length(conceptsToFind)
       
        I = imread(sprintf('./TestImages/challenge%d/letter%d.png',i,predictedImages(i,k)));
        I = single(ones(27,27) - im2bw(double(I))); 
        prototypes = I(:)';
        prediction = clfKnnFwd( clf, prototypes );
        predictedCharacters(i,k)  = letters( prediction );
    end
end


% compute performances

% image recognition performances
diffImages = abs(predictedImages - groundTruthImages);

for i=1:200
    correctImages(i) = length(find(diffImages(i,:)==0));
end

numPassedChallengesImagesOnly1image = length(find(correctImages==1)); % number of challenges for which only 1 image was recognized
numPassedChallengesImagesOnly2images = length(find(correctImages==2)); % number of challenges for which only 2 image was recognized
numPassedChallengesImagesOnly = length(find(correctImages==3)); % number of challenges for which all 3 image were recognized
numRecognizedImages = sum(correctImages);

% total performances after character recognition
numPassedChallenges = 0;
for i=1:200
    stringsMatch = strcmp(predictedCharacters(i,:),groundTruthCharacters(i,:));
    if(stringsMatch)
        numPassedChallenges = numPassedChallenges + 1;
        PassedChallenges(numPassedChallenges) = i;
    end
end

