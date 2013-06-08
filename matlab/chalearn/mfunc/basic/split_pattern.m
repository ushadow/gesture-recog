function pattern_array = split_pattern( pattern, cuts, type )
%pattern_array = split_pattern( pattern, cuts, type )
%   Function that takes a temporal pattern and splits it into a cell array
%   of patterns according to a given temporal segmentation
% Inputs:
% pattern --        A movie or a feature representation of frames, frames
%                   in lines and features in colums.
% cuts --           A matrix Nx2 for N cuts, cuts(k, 1)= start point,
%                   cuts(k, 2) = end point.
% Returns:
% pattern_array --  The cut segments.

% Isabelle Guyon -- June 2012 -- isabelle@clopinet.com

if nargin<3, type='K'; end

if isfield(pattern, 'K') 
    if strcmp(type, 'K')
        pattern=pattern.K';
    else
        pattern=pattern.M';
    end
elseif isfield(pattern, 'cdata')
    pattern=pattern';
end

N=size(cuts,1);
pattern_array=cell(N,1);
for i=1:N
    b=cuts(i,1);
    e=cuts(i,2);
    pattern_array{i}=pattern(b:e,:);
end
    
end

