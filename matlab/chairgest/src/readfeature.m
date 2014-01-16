function [data, startDescriptorNDX, imgWidth, xsensSampleRate, ...
          kinectSampleRate] = readfeature(...
         inputFile, sensor)
%% READFEATURE reads features from one Chairgest data set file.
%
% ARGS
% inputFile - input file name.
% sensor    - the sensor type that the data is based on.
%
% RETURN
% data  - n x d matrix where n is number of feature frames and d is the 
%         dimension of the feature + 1. The first column is frame number.
% xsensSampleRate  - sampling rate with respect to Xsens data frequency.

imgWidth = 0;
xenseKinectRatio = 50 / 30;

if strcmp(sensor, 'Kinect')
  feature = importdata(inputFile, ',', 1);
  data  = feature.data;
  
  % Header format
  header = textscan(feature.textdata{1}, '%s%s%d%s%f%s%f%s%s', 'delimiter', ',');
  startDescriptorNDX = header{3} + 1;
  imgWidth = sqrt(header{5} / 2);
  kinectSampleRate = header{7};
  xsensSampleRate = kinectSampleRate * xenseKinectRatio;
else
  %% Xsens data format in the converted file.
  formatSpec = '%s%f'; % AbsTimeStamp FrameID
  % For each sensor, the data are:
  % SensorId LinAccX/Y/Z, AngVelX/Y/Z, MagX/Y/Z, Yaw, Pitch, Roll,
  % QuatX/Y/Z Baro
  oneSensor = repmat('%f', 1, 18); 
  % There are 4 sensors and the order is: neck, upperarm, forearm, hand.
  formatSpec = [formatSpec repmat(oneSensor, 1, 4)];
  fid = fopen(inputFile);
  % data is a cell array. Each cell contains data for one specifier in the
  % formatSpec.
  data = textscan(fid, formatSpec, 'HeaderLines', 1, 'ReturnOnError', 0);
  NDX = ~isnan(data{3});
  % Ignore the first column which is the timestamp.
  data = cell2mat(data(2 : end));
  data = data(NDX, :);
  startDescriptorNDX = size(data, 2) - 1;
end
end