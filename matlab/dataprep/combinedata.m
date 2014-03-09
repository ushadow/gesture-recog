function combined = combinedata(data)
% COMBINEDATA combines all user data one after the other.
%
% ARGS
% data - cell array of user data.

[Y, X, frame, file] = cellfun(@getfields, data, 'UniformOutput', false);
combined.Y = [Y{:}];
combined.X = [X{:}];
combined.frame = [frame{:}];
combined.file = [file{:}];
combined.param = data{1}.param;
combined = {combined};
end

function [Y, X, frame, file] = getfields(data)
Y = data.Y;
X = data.X;
frame = data.frame;
file = data.file;
end