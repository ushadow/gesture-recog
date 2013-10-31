function data = prepdata(dirname, varargin)
%% PREPAREDATACHAIRGEST prepares the data from CHAIRGEST dataset into right 
% structure for preprocessing.
%
% ARGS
% dirname     - directory of the main database name, i.e. 'chairgest'.
%
% OPTIONAL ARGS
% sensorType  - string of sensor type, i.e., 'Kinect' or 'Xsens'. ['Kinect']
% subsmapleFactor - subsampling factor. [1]
%
% RETRURN
% data  - a cell array. Each cell is for one user and is a structure with fields:
%   Y     - a cell array of ground truth labels.
%   X     - a cell array of features.
%   split - a 2 x 1 cell array with one fold evalutation.

sensorType = 'Kinect';
gtSensorType = 'Kinect';
dataType = 'Converted';

for i = 1 : 2 : length(varargin)
  switch varargin{i}
    case 'sensorType'
      sensorType = varargin{i + 1};
    case 'gtSensorType'
      gtSensorType = varargin{i + 1};
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
        [featureData, startDescriptorNDX, sampleRate] = readfeature(...
            fullfile(sessionDir, fileName), sensorType);
        [gt, vocabSize] = readgt(gtFile, featureData(end, 1));

        if ~paramInitialized
          dataParam.vocabularySize = vocabSize;
          dataParam.startDescriptorNDX = startDescriptorNDX;
          dataParam.dir = dirname;
          dataParam.subsampleFactor = sampleRate;
          dataParam.gtSensorType = gtSensorType;
          dataParam.dataType = dataType;
          paramInitialized = true;
        end
        [Y, X, frame] = alignlabelfeature(gt, featureData);
        data{p}.Y{end + 1} = Y;
        data{p}.X{end + 1} = X;
        data{p}.frame{end + 1} = frame;
        data{p}.file{end + 1} = {pid, sessionName, batchNDXstr};
      end
    end
  end
  data{p}.param = dataParam;
  data{p}.Y = addflabel(data{p}.Y);
end
end