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
  
  function [batches, prefixLen] = getBatchNames(self, pid, session, sensor)
    dirData = dir(fullfile(self.dirname, pid, session));
    name = {dirData.name};
    prefix = [sensor 'Data_'];
    NDX = cellfun(@(x) strstartswith(x, prefix), name);
    batches = name(NDX);
    prefixLen = length(prefix);
  end
end

methods (Static)
  function ret = isSessionName(filename)
    ret = length(filename) > 2;
  end
end
end