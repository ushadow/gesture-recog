function data = prepdatachairgest(dirname, userId, sensorType, ...
                dataType, testPerc, subsampleFactor)
%% PREPAREDATACHAIRGEST prepares the data from CHAIRGEST dataset from one 
% user into right structure for preprocessing.
%
% ARGS
% dirname     - directory of the main database name, i.e. 'chairgest'.
% userId      - integer of user id.
% sensorType  - string of sensor type, i.e., 'Kinect' or 'Xsens'.
%
% RETRURN
% data  - a structure with fields:
% Y     - a cell array of ground truth labels.
% X     - a cell array of features.
% split - a 2 x 1 cell array with one fold evalutation.

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
data.frame = {};
data.file = {};

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
      [featureData, nconFeat] = readfeature(...
          fullfile(sessionDir, fileName), sensorType);

      if ~paramInitialized
        dataParam.vocabularySize = vocabSize;
        dataParam.startImgFeatNDX = nconFeat + 1;
        dataParam.dir = dirname;
        dataParam.subsampleFactor = subsampleFactor;
        dataParam.sensorType = sensorType;
        dataParam.dataType = dataType;
        paramInitialized = true;
      end
      [Y, X, frame] = combinelabelfeature(gt, featureData);
      data.Y{end + 1} = Y;
      data.X{end + 1} = X;
      data.frame{end + 1} = frame;
      data.file{end + 1} = {userId, session{i}, fileNDX};
    end
  end
end
data = subsample(data, subsampleFactor);
data.Y = addflabel(data.Y);
data = setsplit(data, testPerc);
data.param = dataParam;
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