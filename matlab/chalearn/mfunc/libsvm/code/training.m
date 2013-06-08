% generate training data and build classifiers

clear all
clc

% read categories names
load concept

featureTypes = {'colorMomentFeatures' ,  'gistFeatures' , 'colorHistogramFeatures',  'edgeHistogramFeatures'};
modelTypes = {'colorMoment',  'gist' , 'colorHistogram' , 'edgeHistogram'};

featureType =  featureTypes{2};
modelType = modelTypes{2};

svmKnn = 0; % 0 -> SVM
            % 1 -> K-NN
k = 1;            
            
splitIndex = 500;
equalPosNegSplit = 1;

createFeatures = 0;

if(createFeatures)
    
    % extract and save features for all the training images, looping over
    % categories
    for category=17:length(concept) %%%%%%%%%%%%%%%%%%%%%%%%%%
        folder = sprintf('./trainingSet/%s',concept{category});
        images = ls(folder);
        switch(featureType)
            case 'edgeHistogramFeatures' 
                featuresTmp = extractEdgeHistogram(folder, images,category); 
            case 'colorHistogramFeatures' 
                featuresTmp = extractCbCrhist(folder, images, category);
            case 'gistFeatures'
                featuresTmp = extractGistFeatures(folder, images, category);
            case 'colorMomentFeatures'
                featuresTmp = extractColorMoments(folder, images, category);
            otherwise  
                break;    
        end
        features = cell2mat(featuresTmp');
%%%        save(sprintf('%s/edgeHistogramFeatures',folder),'edgeHistogramFeatures');
        save(sprintf('%s/%s',folder,featureType),'features');
    end

    % extract and save features for all the test images, looping over
    % challenges
    for i=1:12
        testImages{i} = sprintf('image%d.png',i);
    end
    testImages = strvcat(testImages);

    for i=1:200
        folder = sprintf('./TestImages/challenge%d',i);
        switch(featureType)
            case 'edgeHistogramFeatures'
                featuresTmp = extractEdgeHistogram(folder, testImages, i);
            case 'colorHistogramFeatures'  
                featuresTmp = extractCbCrhist(folder, testImages, i);
            case 'gistFeatures'
                featuresTmp = extractGistFeatures(folder, testImages, i);
            case 'colorMomentFeatures'
                featuresTmp = extractColorMoments(folder, testImages, i);
            otherwise  
                break; 
        end
        features = cell2mat(featuresTmp');
%%%        save(sprintf('%s/edgeHistogramFeatures',folder),'edgeHistogramFeatures');
        save(sprintf('%s/%s',folder,featureType),'features');
    end

end
    

if(svmKnn)
% % % %     % train a k-NN classifier
% % % %     training_set_labels = [];
% % % %     for category=1:length(concept)
% % % %         concept{category}
% % % %         folder = sprintf('./trainingSet/%s',concept{category});
% % % %         load(sprintf('%s/%s',folder,featureType));
% % % %         [featureHeight featureWidth] = size(features);
% % % %         vertcat(training_set_labels,ones(featureHeight,1)*category);
% % % %     end
% % % %     clf = clfKnn( featureWidth, k,'sqeuclidean' );
% % % %     clf = clfKnnTrain( clf, training_set, uint8(training_set_labels) ) ;
    
else
    % prepare the training data for each category, with its features (~500) as
    % positive data and an equal amount of negative examples randomly
    % sampled from the other categories and then train an SVM classifier on it
    for category=1:length(concept)
        concept{category}
        folder = sprintf('./trainingSet/%s',concept{category});
        %%%    load(sprintf('%s/edgeHistogramFeatures',folder));
        load(sprintf('%s/%s',folder,featureType));

        % keep only the first splitIndex images from the positive training data
        features(splitIndex+1:end,:) = [];

        classIndex = size(features,1);
        for i=1:length(concept)
            if(i~=category)
                folderTmp = sprintf('./trainingSet/%s',concept{i});
                %%%            featureNeg = load(sprintf('%s/edgeHistogramFeatures',folderTmp));
                featureNeg = load(sprintf('%s/%s',folderTmp,featureType));
                if(equalPosNegSplit)
                    index = randperm(490);
                    index = index(1:floor(classIndex/25));
                else
                    index = [1:size(featureNeg,1)];
                end
                features = vertcat(features,featureNeg.features(index,:));
            end
        end
        % compute mean and standard deviation of the training features
        meanFeaturesTrain = mean(features);
        stdDevFeaturesTrain = std(features);

        % perform the "whitening" normalization of the whole feature set
        for i=1:size(features,1)
            features(i,:) = ( features(i,:) - meanFeaturesTrain )./ (stdDevFeaturesTrain+0.001);
        end

        % save training data in the appropriate format
        %%%    prepareData(sprintf('%s/edgeHistogramFeatures.txt',folder),edgeHistogramFeatures,classIndex);
        indexTmp = isnan(features);
        indexNaN = find(indexTmp==1);
        features(indexNaN) = 0;


        prepareData(sprintf('%s/%s.txt',folder,featureType),features,classIndex);

        % train the SVM on the training data
        %%%    system(sprintf('svm-train.exe -b 1 "%s/edgeHistogramFeatures.txt"',folder));
        %%%    movefile('edgeHistogramFeatures.txt.model',sprintf('%s/edgeHistogram.model',folder));
        system(sprintf('svm-train.exe -b 1 "%s/%s.txt"',folder,featureType));
        movefile(sprintf('%s.txt.model',featureType),sprintf('%s/%s.model',folder,modelType));
    end
end

% prepare the test data
for i=1:200
    folder = sprintf('./TestImages/challenge%d',i);
%    load(sprintf('%s/edgeHistogramFeatures',folder));
%    prepareData(sprintf('%s/edgeHistogramFeatures.txt',folder),edgeHistogramFeatures,12);
    load(sprintf('%s/%s',folder,featureType));
    for j=1:size(features,1)
        features(j,:) = ( features(j,:) - meanFeaturesTrain )./ (stdDevFeaturesTrain+0.001);
    end
    indexTmp = isnan(features);
    indexNaN = find(indexTmp==1);
    features(indexNaN) = 0;
    prepareData(sprintf('%s/%s.txt',folder,featureType),features,12);
end





