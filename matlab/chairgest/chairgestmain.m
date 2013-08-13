function chairgestmain(dirname)
%%
% ARGS
% dirname   - the directory of the main database containing the
%             folders for each user ID.

sensorType = 'Kinect';        
dataParam.vocabularySize = 13;
dataParam.dir = fullfile(pwd, 'data');
dataParam.subsampleFactor = 2;
dataParam.gtSensorType = 'Xsens';
dataParam.dataType = 'Converted';
modelFile = fullfile(pwd, 'model.mat');
matObj = matfile(modelFile);
model = matObj.model;
param = model.param;

if exist(dataParam.dir, 'dir') == 0
  extractfeature(dirname, dataParam.dir)
end

data = getdata(dataParam.dir, sensorType);
data = subsample(data, dataParam.subsampleFactor);
data.param = dataParam;
X.Va = data.X;
result.split = {[]; 1 : length(X.Va)};

if isfield(param, 'preprocess')
  npreprocesses = length(param.preprocess); 
  for i = 1 : npreprocesses
    fun = param.preprocess{i};
    X  = fun(X, param, 'model', model.preprocessModel{i});
  end
end

result.prediction = param.inference([], X, model.learnedModel, param);
result.param.dir = pwd;
outputchairgest(data, {result}, 'hmm', 'yingyin', gesturelabel);
end

function [X, frame] = separateframe(feature)
startFrame = 200;
X = feature(startFrame : end, 2 : end)';
frame = feature(startFrame : end, 1)';
end

function data = getdata(dirname, sensorType)
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
    [batch, prefixLen] = dataSet.getBatchNames(pid, sessionName, sensorType);

    for j = 1 : length(batch)
      fileName = batch{j};
      fileNDX = fileName(prefixLen + 1);
      if str2double(fileNDX) > 0
        fullPath = fullfile(sessionDir, fileName);
        logdebug('chairgestmain', 'batch', fullPath);
        featureData = readfeature(fullPath, sensorType);

        [X, frame] = separateframe(featureData);
        data.X{end + 1} = X;
        data.frame{end + 1} = frame;
        data.file{end + 1} = {pid, sessionName, fileNDX};
      end
    end
  end
end

end