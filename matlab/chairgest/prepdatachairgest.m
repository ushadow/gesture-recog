function [data, dataParam] = prepdatachairgest(dirname, userId)
% PREPAREDATACHAIRGEST prepares the data from CHAIRGEST dataset into right 
% structure for preprocessing.

% Args:
% - dirname: directory of the main database name, i.e. 'chairgest'.
% - userId: integer of user id.
%
% Return:
% - data: a structure with fields:
%   - Y: a cell array of ground truth labels.
%   - X: a cell array of features.
%   - split: a 2 x 1 cell array with one fold evalutation.
userId = sprintf('PID-%010d', userId);
piddir = [dirname filesep userId];
session = getsession(piddir);
data.userId = userId;
data.Y = {};
data.X = {};

paramInitialized = false;
for i = 1 : 2
  sessionDir = fullfile(piddir, session{i});
  logdebug('prepdatachairgest', 'sessionDir', sessionDir);
  batch = getbatchname(sessionDir);
  
  for j = 1 : length(batch)
    fileName = batch{j};
    logdebug('prepdatachairgest', 'batch', fileName);
    fileNDX = fileName(12);
    gtFile = [sessionDir filesep 'KinectDataGTD_' fileNDX '.txt'];
    [gt, vocabSize] = readkinectgt(gtFile);
    [featureData, nconFeat] = readfeature(fullfile(sessionDir, fileName));

    if ~paramInitialized
      dataParam.vocabularySize = vocabSize;
      dataParam.startImgFeatNDX = nconFeat + 1;
      dataParam.dir = dirname;
      paramInitialized = true;
    end
    [Y, X] = combinelabelfeature(gt, featureData);
    data.Y{end + 1} = Y;
    data.X{end + 1} = X;
  end
end
data.Y = addFlabel(data.Y);
data = setsplit(data);
end

function batch = getbatchname(dirname)
%% GETBATCHNAME get the batch names from a directory.
dirData = dir(dirname);
name = {dirData.name};
NDX = cellfun(@(x) strstartswith(x, 'KinectData_'), name);
batch = name(NDX);
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

function [Y, X] = combinelabelfeature(label, feature)
%% Combines label and feature with common frame id.
%
% ARGS
% label   - matrix of all labels for a batch.
% feature - matrix of all features for a batch.

labelFrameId = label(:, 1);
featureFrameId = feature(:, 1);
[~, labelNDX, featureNDX] = intersect(labelFrameId, featureFrameId);
Y = label(labelNDX, 2 : 3)';
X = feature(featureNDX, 2 : end)';
end