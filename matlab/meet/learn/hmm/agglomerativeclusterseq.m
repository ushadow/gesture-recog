function clusters = agglomerativeclusterseq(dist, k, varargin)
% labels = agglomerative_cluster(data, k)
%    Cluster data using the following algorithm:
%    Initially, place each data point in its own cluster.
%    Until the number of clusters is k, merge the two nearest clusters.
%
%    The distance between clusters can be computed in three different
%    ways: 
%    1) simple - the distance between the two nearest points in
%       either class
%    2) average - the average distance between the points in the two 
%       classes
%    3) complete - the maximum distance between between points in the
%       two classes 
%    In all of these, the distance between points is the squared 
%    Eucledian distance.
%
% Required Arguments:
%    data = cell array of sequence data to cluster
%    k    = final number of classes
%
% Optional Arguments:
%    linkage = 'simple', 'average', or  'complete'
%    labels  = a vector containing the true labels of the data
%              If this is available, a measure of performance
%              will be displayed after each iteration.
%
% Output:
%    labels = the cluster assignments for each data vector
%
% Author: David Ross, Sept. 11, 2003.

%----------------------------------------------------------
% Check arguments.
%----------------------------------------------------------

if floor(k) ~= k || k < 1
    error('k must be an positive integer');
end

% linkage 'simple' => 0, 'average' => 1, 'complete' => 2
linkage = 0;

% remaining arguments
for vv = 1:length(varargin)

    % if the input is a string, it probably specifies the linkage method
    if ischar(varargin{vv})
        if strcmp(varargin{vv},'simple')
            linkage = 0;
        elseif strcmp(varargin{vv},'average')
            linkage = 1;
        elseif strcmp(varargin{vv},'complete')
            linkage = 2;
        else
            error('unknown argument %s',varargin{vv});
        end
    % otherwise, the argument is unknown    
    else
        error('argument %d is unknown',vv+2);
    end
    
end


%----------------------------------------------------------
% Main...
%----------------------------------------------------------

N = size(dist, 1);

% Clusters is a cell array of vectors.  Each vector contains the
% indicies of the points belonging to that cluster.
% Initially, each point is in it's own cluster.
clusters = cell(N, 1);
for cc = 1:length(clusters)
    clusters{cc} = cc;
end

% until the termination condition is met
while length(clusters) > k
    
    % compute the distances between all pairs of clusters
    cluster_dist = inf*ones(length(clusters));
    for c1 = 1:length(clusters)
        for c2 = (c1+1):length(clusters)
            cluster_dist(c1, c2) = cluster_distance(clusters{c1},...
                clusters{c2}, dist, linkage);
        end
    end
    
    % merge the two nearest clusters
    [~, ii] = min(cluster_dist(:));
    [ii(1), ii(2)] = ind2sub(size(cluster_dist), ii(1));
    clusters = merge_clusters(clusters, ii);
end

end

%//////////////////////////////////////////////////////////
% d = cluster_distance(c1,c2,point_dist,linkage)
%    Computes the pairwise distances between clusters c1
%    and c2, using the point distance info in point_dist.
%----------------------------------------------------------
function d = cluster_distance(c1,c2,point_dist,linkage)

d = point_dist(c1,c2);

switch linkage
    case 0
        % -- Simple Linkage --
        % distance between two nearest points
        d = min(d(:));
        
    case 1
        % -- Average Linkage --
        % average distance between points in the two clusters
        d = mean(d(:));
        
    case 2
        % -- Complete Linkage --
        % distance between two furthest points
        d = max(d(:));

    otherwise
        error('unknown linkage');
end
end

%//////////////////////////////////////////////////////////
% clusters = merge_clusters(clusters, indicies)
%   Merge the clusters indicated by the entries indicies(1)
%   and indicies(2) of cell array 'clusters'.
%----------------------------------------------------------
function clusters = merge_clusters(clusters, indicies)
clusters{indicies(1)} = [clusters{indicies(1)} clusters{indicies(2)}];
clusters(indicies(2)) = [];
end