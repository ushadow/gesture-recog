function chairgestmain(dirname, extract)
%%
% ARGS
% dirname   - the directory of the main database containing the
%             folders for each user ID.
% extract   - [optional] if true, performs feature extraction. Default is
%             true.

tic;

if nargin < 2
  extract = true;
end

addpath(genpath(fullfile(pwd, 'lib')), '-end');
addpath(genpath(fullfile(pwd, 'src')), '-end');

sensorType = 'Kinect';        

dataParam.vocabularySize = 13;
dataParam.dir = fullfile(pwd, 'data');
dataParam.gtSensorType = 'Xsens';
dataParam.dataType = 'Converted';

modelFile = fullfile(pwd, 'model.mat');
matObj = matfile(modelFile);
model = matObj.model;
param = model.param;

if extract
  [~, ~] = rmdir(dataParam.dir, 's'); % Removes existing directory.
  extractfeature(dirname, dataParam.dir);
end

[data, featureSampleRate] = getdata(dataParam.dir, sensorType);
assert(mod(param.subsampleFactor, featureSampleRate) == 0);
subsampleRate = param.subsampleFactor / featureSampleRate;
if subsampleRate > 1
  data = subsample(data, subsmapleRate);
end
data.param = dataParam;
X.Va = data.X;
nseqs = length(X.Va);

if nseqs <= 0
  error('Wrong input directory. No input found. Use RAW feature input directory.');
end

result.split = {[]; 1 : nseqs};

if isfield(param, 'preprocess')
  npreprocesses = length(param.preprocess); 
  for i = 1 : npreprocesses
    fun = param.preprocess{i};
    X  = fun(X, param, 'model', model.preprocessModel{i});
  end
end

result.prediction = param.inference([], X, model.learnedModel, param);
result.param.dir = pwd; % output directory
outputchairgest(data, {result}, 'hmm', 'yingyin', gesturelabel);
toc;
end

function [X, frame] = separateframe(feature, fileNDX, sampleRate)
%% Separates frame indices from features.

startFrame = 1;

if fileNDX == 1
  % Ignores the first 400 frames. This is before subsampling.
  startFrame = 400 / sampleRate;
end

X = feature(startFrame : end, 2 : end)';
frame = feature(startFrame : end, 1)';
end

function [data, sampleRate] = getdata(dirname, sensorType)
dataSet = ChairgestData(dirname);
pids = dataSet.getPIDs;
npids = length(pids);

data.X = {};
data.frame = {};
data.file = {};
        
for p = 1 : npids
  pid = pids{p};
  sessionNames = dataSet.getSessionNames(pid);

  for i = 1 : length(sessionNames)
    sessionName = sessionNames{i};
    sessionDir = fullfile(dirname, pid, sessionName);
    [batch, ndx] = dataSet.getBatchNames(pid, sessionName, sensorType);

    for j = 1 : length(batch)
      fileName = batch{j};
      fileNDXstr = ndx{j};
      fileNDX = str2double(fileNDXstr);
      if fileNDX > 0
        fullPath = fullfile(sessionDir, fileName);
        fprintf('Read batch: %s.\n', fullPath);
        [featureData, ~, sampleRate] = readfeature(fullPath, sensorType);

        [X, frame] = separateframe(featureData, fileNDX, sampleRate);
        data.X{end + 1} = X;
        data.frame{end + 1} = frame;
        data.file{end + 1} = {pid, sessionName, fileNDXstr};
      end
    end
  end
end

end