function data = prepdatachairgest(dirname, varargin)
%% PREPAREDATACHAIRGEST prepares the data from CHAIRGEST dataset from one 
% user into right structure for preprocessing.
%
% ARGS
% dirname     - directory of the main database name, i.e. 'chairgest'.
% sensorType  - string of sensor type, i.e., 'Kinect' or 'Xsens'.
%
% RETRURN
% data  - a structure with fields:
% Y     - a cell array of ground truth labels.
% X     - a cell array of features.
% split - a 2 x 1 cell array with one fold evalutation.

sensorType = 'Kinect';
gtSensorType = sensorType;
testPerc = 0.33; 
dataType = 'Converted'; 
subsampleFactor = 1; 

for i = 1 : 2 : length(varargin)
  switch varargin{i}
    case 'sensorType'
      sensorType = varargin{i + 1};
    case 'gtSensorType'
      gtSensorType = varargin{i + 1};
    case 'testPerc'
      testPerc = varargin{i + 1};
    case 'subsampleFactor'
      subsampleFactor = varargin{i + 1};
    otherwise
      error(['Unrecognized option: ' varargin{i}]);
  end
end

gtFileFormat = [gtSensorType 'DataGTD_%s.txt'];

dataSet = ChairgestData(dirname);
pids = dataSet.getPIDs;
npids = length(pids);
data = cell(1, npids);
for p = 1 : npids
  pid = pids{p};
  sessionNames = dataSet.getSessionNames(pid);
  data{p}.userId = pid;
  data{p}.Y = {};
  data{p}.X = {};
  data{p}.frame = {};
  data{p}.file = {};

  paramInitialized = false;
  for i = 1 : length(sessionNames)
    sessionName = sessionNames{i};
    sessionDir = fullfile(dirname, pid, sessionName);
    [batch, prefixLen] = dataSet.getBatchNames(pid, sessionName, sensorType);

    for j = 1 : length(batch)
      fileName = batch{j};
      fileNDX = fileName(prefixLen + 1);
      if str2double(fileNDX) > 0
        gtFile = fullfile(sessionDir, sprintf(gtFileFormat, fileNDX));
        logdebug('prepdatachairgest', 'batch', gtFile);
        [gt, vocabSize] = readgtchairgest(gtFile);
        [featureData, nconFeat] = readfeature(...
            fullfile(sessionDir, fileName), sensorType);

        if ~paramInitialized
          dataParam.vocabularySize = vocabSize;
          dataParam.startImgFeatNDX = nconFeat + 1;
          dataParam.dir = dirname;
          dataParam.subsampleFactor = subsampleFactor;
          dataParam.gtSensorType = gtSensorType;
          dataParam.dataType = dataType;
          paramInitialized = true;
        end
        [Y, X, frame] = combinelabelfeature(gt, featureData);
        data{p}.Y{end + 1} = Y;
        data{p}.X{end + 1} = X;
        data{p}.frame{end + 1} = frame;
        data{p}.file{end + 1} = {pid, sessionName, fileNDX};
      end
    end
  end
  data{p} = subsample(data{p}, subsampleFactor);
  data{p}.Y = addflabel(data{p}.Y);
  data{p}.param = dataParam;
  data{p}.split = getsplit(data{p}, testPerc);
end
end

function [Y, X, frame] = combinelabelfeature(label, feature)
%% Combines label and feature with common frame id.
%
% ARGS
% label   - matrix of all labels for a batch.
% feature - matrix of all features for a batch. Each row is an observation.
% 
% RETURNS
% Y   - cell array of labels. Each cell is a 2 x nframe matrix.
% X   - cell array of feature vectors. Each cell is a d x nframe matrix. 
% frame   - cell arrays of frame numbers. Each cell is a 1 x nframe matrix.

labelFrameId = label(:, 1);
featureFrameId = feature(:, 1);
% Finds common frames.
[frame, labelNDX, featureNDX] = intersect(labelFrameId, featureFrameId);
Y = label(labelNDX, 2 : 3)';
X = feature(featureNDX, 2 : end)';
frame = frame(:)';
assert(size(Y, 2) == size(frame, 2));
end