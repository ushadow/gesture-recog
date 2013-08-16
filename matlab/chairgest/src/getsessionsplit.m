function split = getsessionsplit(dirname, sensorType)
%% GETSESSIONSPLIT creates the training and testing split according to sessions.
%
% ARGS
% data     - struct of MEET data.
% testPerc - percentage of test data.

dataset = ChairgestData(dirname);
pids = dataset.getPIDs;
sessionSplit = [];
count = 0;
for i = 1 : length(pids)
  sessions = dataset.getSessionNames(pids{i});
  nsessions = length(sessions);
  if isempty(sessionSplit)
    sessionSplit = cell(1, nsessions);
  end
  for s = 1 : nsessions
    batches = dataset.getBatchNames(pids{i}, sessions{s}, sensorType); 
    nbatches = length(batches);
    sessionSplit{s} = [sessionSplit{s} count + (1 : nbatches)]; %#ok<AGROW>
    count = count + nbatches;
  end
end

nfolds = length(sessionSplit);
split = cell(3, nfolds);
for i = 1 : nfolds
  split{2, i} = sessionSplit{i};
  split{1, i} = cat(2, sessionSplit{[1 : i - 1, i + 1 : end]});
end
end