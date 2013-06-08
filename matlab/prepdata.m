function [data, segFrameId, dataParam] = prepdata(dirname, suffix, userId)
% PREPTRAININGDATA prepares the training data into right structure for 
% preprocesssing.
%
% Args:
% - suffix: suffix of the feature file, e.g. '-100'.
% - userID: an optional string or cell array of userIDs indicating the user 
%           data to be imported.
%
% Return
% - data: a struct. data.Y is the label and data.X is the feature.
%         Each field is a cell array of N x M cell arrays. Each seconde
%         leve cell array represents a sequence. 
files = dir(dirname);
for i = 1 : length(files)
  file = files(i);
  if ~file.isdir
    name = file.name;
    indices = strfind(name, '.');
    last_index = indices(1);
    basename = name(1 : last_index - 1); % without extension.
    ext = name(last_index + 1 : end);
    if strcmp(ext, 'glab.csv') && isuserfile(basename, userId)
      labelFile = [dirname name];
      label = importdata(labelFile, ',', 1);
      logdebug('prepdata', 'label file', labelFile);
      featureFile = [dirname basename suffix '.gfet'];
      logdebug('prepdata', 'feature file', featureFile);
      [featureData, nconFet, imageWidth] = readfeature(featureFile);
      % Init parameters.
      dataParam.nconFet = nconFet;
      dataParam.vocabularySize = length(unique(label.data(:, 2)));
      dataParam.imageSize = imageWidth * imageWidth; 
      dataParam.dir = dirname;
      [data, segFrameId] = combinelabelfeature(label.data, featureData, ...
                                               dataParam);
      data.userId = userId;
      data.split = getnfoldindex(numel(data.X), 0, 10);
    end
  end
end
end

function b = isuserfile(basename, userID)
  b = isempty(userID) || any(strncmp(basename, userID, length(basename)));
end

function [data, segFrameId] = combinelabelfeature(label, feature, param)
labelFrameId = label(:, 1);
featureFrameId = feature(:, 1);
[frameids, labelNDX, featureNDX] = intersect(labelFrameId, featureFrameId);
logdebug('preptrainingdata', 'number of frames', length(frameids));
[segment, segFrameId] = createsegment(frameids); % cell array
label = label(labelNDX, 2 : end); % Removes frame ID.
feature = feature(featureNDX, 2 : end); % Each row is a feature vector.

assert(size(label, 1) == size(feature, 1));

data.Y = cell(1, length(segment));
data.X = cell(1, length(segment));
for i = 1 : length(segment)
  indices = segment{i};
  T = length(indices);
  data.Y{i} = num2cell(label(indices, 1 : 2)');
  featureSeg = feature(indices, :)';
  data.X{i} = mat2cell(featureSeg, param.nconFet + param.imageSize, ...
                       ones(1, T));

  assert(all(size(data.Y{i}) == [2, T]));
  assert(length(data.X{i}{T}) == param.nconFet + param.imageSize);
end
end

function [seg, segFrameId] = createsegment(frameid)
% segments = segment(frameids) finds the segments in a vector of frame 
% IDs. A segment is a sequence of continuous frame IDs. 
% 
% Args
% frameids: a vector of frame IDs.
%
% Returns
% A cell array of indices vectors. Each vector is a continuous indices into
% the input frame ID vector.
seg = {};
segFrameId = {};
startNDX = 1;
nframe = length(frameid);
for i = 2 : nframe
  if frameid(i) - 1 ~= frameid(i - 1) ||  i == nframe
    if frameid(i) - 1 ~= frameid(i - 1)
      lastNDX = i - 1;
    elseif i == nframe
      lastNDX = i;
    end
    seg{end + 1} = startNDX : lastNDX; %#ok<AGROW>
    segFrameId{end + 1} = frameid(startNDX : lastNDX); %#ok<AGROW>
    startNDX = i;
  end
end

nframe = 0;
for i = 1 : length(seg)
  nframe = nframe + length(seg{i});
end
assert(nframe == length(frameid));
end

function valid = checklabel(label)
% Checks the validity of G, F labeling.
nrows = size(label, 1);
for i = 1 : nrows - 1
  if label(i, 1) ~= label(i + 1, 1)
    valid = label(i, 2) == 2;
    if ~valid
      disp(label(i, :));
      disp(label(i + 1, :));
      return;
    end
  end
end
end