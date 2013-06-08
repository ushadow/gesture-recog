function [X,Y] = inst2seq(I,X,Y)
% [X,Y] = inst2seq(I,X,Y)
%
% Input:
%   - I : n-by-1 sequence ids of each instance
%   - X : n-by-m matrix of n instances (m-dimensional feature vector)
%   - Y : n-by-1 vector of n labels (optional)
%
% Output:
%   - X : 1-by-k cell array of k sequence of instances
%   - Y : 1-by-k cell array of k sequence labels
%
% See also:
% SEQ2INST
    
unique_I = unique(I);

xx = cell(1,numel(unique_I));
for i=1:numel(unique_I)
    id = unique_I(i);
    xx{id} = X(I==id,:)';
end
X=xx;

if exist('Y','var')
    Y2 = cell(1,numel(unique_I));
    for i=1:numel(unique_I)
        id = unique_I(i);
        Y2{id} = Y(I==id)';
    end
    Y=Y2;
end



