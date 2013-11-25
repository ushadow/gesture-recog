function data = prepdatachairgest(dirname, varargin)
%% PREPAREDATACHAIRGEST prepares the data from CHAIRGEST dataset into right 
% structure for preprocessing. All session data are concatenated one after 
% another.
%
% ARGS
% dirname     - directory of the main database name, i.e. 'chairgest'.
%
% OPTIONAL ARGS
% sensorType  - string of sensor type, i.e., 'Kinect' or 'Xsens'. ['Kinect']
% subsmapleFactor - subsampling factor. [1]
% gtSensorType  - ground truth reference sensor. ['Kinect'] 
%
% RETRURN
% data  - a cell array. Each cell is for one user and is a structure with fields:
%   Y     - a cell array of ground truth labels.
%   X     - a cell array of features.
%   split - a 2 x 1 cell array with one fold evalutation.

sensorType = 'Kinect';
gtSensorType = 'Kinect';
dataType = 'Converted'; 
subsampleFactor = 1; 
featureSampleRate = 4;

for i = 1 : 2 : length(varargin)
  switch varargin{i}
    case 'sensorType'
      sensorType = varargin{i + 1};
    case 'gtSensorType'
      gtSensorType = varargin{i + 1};
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
    [batches, ndx] = dataSet.getBatchNames(pid, sessionName, sensorType);

    for j = 1 : length(batches)
      fileName = batches{j};
      batchNDXstr = ndx{j};
      batchNDX = str2double(batchNDXstr);
      if batchNDX > 0
        gtFile = fullfile(sessionDir, sprintf(gtFileFormat, batchNDXstr));
        logdebug('prepdatachairgest', 'batch', gtFile);
        [featureData, descriptorStartNdx, imgWidth] = readfeature(...
            fullfile(sessionDir, fileName), sensorType);
        [gt, vocabSize] = readgtchairgest(gtFile, featureData(1, 1), ...
            featureData(end, 1));

        if ~paramInitialized
          dataParam.vocabularySize = vocabSize;
          dataParam.startImgFeatNDX = descriptorStartNdx;
          dataParam.dir = dirname;
          dataParam.subsampleFactor = subsampleFactor * featureSampleRate;
          dataParam.gtSensorType = gtSensorType;
          dataParam.dataType = dataType;
          dataParam.imgWidth = imgWidth;
          paramInitialized = true;
        end
        [Y, X, frame] = combinelabelfeature(gt, featureData, batchNDX, ...
                                            featureSampleRate);
        data{p}.Y{end + 1} = Y;
        data{p}.X{end + 1} = X;
        data{p}.frame{end + 1} = frame;
        data{p}.file{end + 1} = {pid, sessionName, batchNDXstr};
      end
    end
  end
  data{p} = subsample(data{p}, subsampleFactor);
  data{p}.Y = addflabel(data{p}.Y);
  data{p}.param = dataParam;
end
end

function [Y, X, frame] = combinelabelfeature(label, feature, batchNDX, ...
    featureSampleRate)
%% Combines label and feature with common frame id.
%
% ARGS
% label   - matrix of all ground truth labels for a batch.
% feature - matrix of all features for a batch. Each row is an observation.
% 
% RETURNS
% Y   - cell array of labels. Each cell is a 2 x nframe matrix.
% X   - cell array of feature vectors. Each cell is a d x nframe matrix. 
% frame   - cell arrays of frame numbers. Each cell is a 1 x nframe matrix.

startNDX = 400 / featureSampleRate;

if batchNDX == 1
  feature = feature(startNDX : end, :);
end

labelFrameId = label(:, 1);
featureFrameId = feature(:, 1);
% Finds common frames.
[frame, labelNDX, featureNDX] = intersect(labelFrameId, featureFrameId);
Y = label(labelNDX, 2 : 3)';
X = feature(featureNDX, 2 : end)';
frame = frame(:)';
assert(size(Y, 2) == size(frame, 2));
end