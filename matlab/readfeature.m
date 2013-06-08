function [data, nconFeat, imageWidth] = readfeature(inputFile)
feature = importdata(inputFile, ',', 1);
header = textscan(feature.textdata{1}, '%s%s%d%s%d', 'delimiter', ',');
data  = feature.data;
nconFeat = header{3};
imageWidth = header{5};
end