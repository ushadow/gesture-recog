classdef ChairgestData < handle
%% Class represents Chairgest data set folder structure.
properties (Constant)
  PID_PATTERN = 'PID-*';
end

properties
  dirname
end
  
methods
  function obj = ChairgestData(dirname)
    obj.dirname = dirname;
  end
  
  function pids = getPIDs(self)
  %% RETURNS 
  %  pids   - cell array of PIDs
  
    dirData = dir(fullfile(self.dirname, ChairgestData.PID_PATTERN));
    pids = {dirData.name};
  end
  
  function sessions = getSessionNames(self, pid)
  % ARGS
  % pid   - PID name.
  
    dirData = dir(fullfile(self.dirname, pid));
    name = {dirData.name};
    NDX = cellfun(@ChairgestData.isSessionName, name);
    sessions = name(NDX);
  end
  
  function [batches, ndx] = getBatchNames(self, pid, session, sensor)
    fileData = dir(fullfile(self.dirname, pid, session));
    name = {fileData.name};
    pat = [sensor 'Data_(\d+)\.csv'];
    [batches, ndx] = cellfun(@(x) regexp(x, pat, 'match', 'tokens', 'once'), name, ...
          'UniformOutput', false);
    batches = batches(~cellfun('isempty', batches));
    ndx = ndx(~cellfun('isempty', ndx));
    ndx = cellfun(@(x) x{1}, ndx, 'UniformOutput', false);
  end
end

methods (Static)
  function ret = isSessionName(filename)
    ret = length(filename) > 2 && filename(1) ~= 'i';
  end
end
end