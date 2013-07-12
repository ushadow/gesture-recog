function [data, dataParam] = prepdatachairgest(dirname, userId, ...
    sensorType, testPerc, subsampleFactor)
% PREPAREDATACHAIRGEST prepares the data from CHAIRGEST dataset into right 
% structure for preprocessing.

% ARGS
% dirname     - directory of the main database name, i.e. 'chairgest'.
% userId      - integer of user id.
% sensorType  - string of sensor type.
%
% Return:
% data  - a structure with fields:
%   Y   - a cell array of ground truth labels.
%   X   - a cell array of features.
%   split   - a 2 x 1 cell array with one fold evalutation.

if nargin < 3
  sensorType = 'Kinect';
end

if nargin < 4
  testPerc = 0.1;
end

gtFilePrefix = [sensorType 'DataGTD_'];

userId = sprintf('PID-%010d', userId);
piddir = [dirname filesep userId];
session = getsession(piddir);
data.userId = userId;
data.Y = {};
data.X = {};
data.timestamp = {};

paramInitialized = false;
for i = 1 : 3
  sessionDir = fullfile(piddir, session{i});
  logdebug('prepdatachairgest', 'sessionDir', sessionDir);
  [batch, prefixLength] = getbatchname(sessionDir, sensorType);
  
  for j = 1 : length(batch)
    fileName = batch{j};
    fileNDX = fileName(prefixLength + 1);
    if str2double(fileNDX) > 0
      logdebug('prepdatachairgest', 'batch', fileName);
      gtFile = [sessionDir filesep gtFilePrefix fileNDX '.txt'];
      [gt, vocabSize] = readgtchairgest(gtFile);
      [featureData, nconFeat, timestamp] = readfeature(...
          fullfile(sessionDir, fileName), sensorType);

      if ~paramInitialized
        dataParam.vocabularySize = vocabSize;
        dataParam.startImgFeatNDX = nconFeat + 1;
        dataParam.dir = dirname;
        paramInitialized = true;
      end
      [Y, X, timestamp] = combinelabelfeature(gt, featureData, timestamp);
      data.Y{end + 1} = Y;
      data.X{end + 1} = X;
      data.timestamp{end + 1} = timestamp;
    end
  end
end
data = subsample(data, subsampleFactor);
data.Y = addFlabel(data.Y);
data = setsplit(data, testPerc);
end

function [batch, prefixLength] = getbatchname(dirname, sensor)
%% GETBATCHNAME get the batch names from a directory.
%
% ARGS
% sensor  - sensor type.

dirData = dir(dirname);
name = {dirData.name};
prefix = [sensor 'Data_'];
NDX = cellfun(@(x) strstartswith(x, prefix), name);
batch = name(NDX);
prefixLength = length(prefix);
end

function session = getsession(dirname)
dirData = dir(dirname);
name = {dirData.name};
NDX = cellfun(@issessionname, name);
session = name(NDX);
end

function isSessionName = issessionname(filename)
  isSessionName = length(filename) > 2;
end

function [Y, X, timestamp] = combinelabelfeature(label, feature, timestamp)
%% Combines label and feature with common frame id.
%
% ARGS
% label   - matrix of all labels for a batch.
% feature - matrix of all features for a batch. Each row is an observation.

labelFrameId = label(:, 1);
featureFrameId = feature(:, 1);
[~, labelNDX, featureNDX] = intersect(labelFrameId, featureFrameId);
Y = label(labelNDX, 2 : 3)';
X = feature(featureNDX, 2 : end)';
timestamp = timestamp(featureNDX)';
assert(size(Y, 2) == size(timestamp, 2));
end