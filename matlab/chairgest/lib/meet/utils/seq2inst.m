function [I,X,Y] = seq2inst(X,Y)
% [I,X,Y] = seq2inst(X,Y)
%
% Input:
%   - X : 1-by-k cell array of k sequence of instances
%   - Y : 1-by-k cell array of k sequence labels (optional)
%
% Output:
%   - I : n-by-1 sequence ids of each instance
%   - X : n-by-m matrix of n instances (m-dimensional feature vector)
%   - Y : n-by-1 vector of n labels
%
% See also:
% INST2SEQ

I = cellfun(@(x) zeros(1,size(x,2)), X, 'UniformOutput', false);
for i=1:numel(I), 
    I{i} = I{i}+i; 
end

I = cell2mat(I)';
X = cell2mat(X)';

if exist('Y','var')
    Y = cell2mat(Y)';
end
