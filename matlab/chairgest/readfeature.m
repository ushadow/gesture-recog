function [data, nconFeat, timestamp] = readfeature(...
    inputFile, sensor)
%% READFEATURE reads features from the Chairgest data set.

if strcmp(sensor, 'Kinect')
  feature = importdata(inputFile, ',', 1);
  data  = feature.data;
  header = textscan(feature.textdata{1}, '%s%s%d%s%d', 'delimiter', ',');
  nconFeat = header{3};
  timestamp = [];
else
  formatSpec = '%s%f';
  oneSensor = repmat('%f', 1, 18);
  formatSpec = [formatSpec repmat(oneSensor, 1, 4)];
  fid = fopen(inputFile);
  data = textscan(fid, formatSpec, 'HeaderLines', 1, 'ReturnOnError', 0);
  NDX = ~isnan(data{3});
  timestamp = data{1}(NDX);
  data = cell2mat(data(2 : end));
  data = data(NDX, :);
  nconFeat = size(data, 2) - 1;
end
end