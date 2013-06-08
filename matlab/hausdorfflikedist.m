function [hd D] = hausdorfflikedist(P,Q,lmf)
% Calculates the Hausdorff Distance between P and Q
%
% hd = HausdorffDist(P,Q)
% [hd D] = HausdorffDist(P,Q)
% [hd D] = HausdorffDist(...,lmf)
%
% Calculates the Hausdorff Distance, hd, between two sets of points, P and
% Q (which could be two trajectories). Sets P and Q must be matricies with
% an equal number of columns (dimensions), though not necessarily an equal
% number of rows (observations).
%
% The Directional Hausdorff Distance (dhd) is defined as:
% dhd(P,Q) = max p c P [ min q c Q [ ||p-q|| ] ].
% Intuitively dhd finds the point p from the set P that is farthest from
% any point in Q and measures the distance from p to its nearest neighbor
% in Q.
% 
% The Hausdorff Distance is defined as max{dhd(P,Q),dhd(Q,P)}
%
% The Huasdorff-like Distance uses sum instead of max operation. In the end
% an root mean square distance is returned.
%
% D is the matrix of distances where D(n,m) is the distance of the nth
% point in P from the mth point in Q.
%
% Note: If the size of P and Q are very large, the matrix of distances
% between them, D, will be too large to store in memory. Therefore, the
% function will check your available memory and not build the D matrix if
% it will exceed your available memory and instead use a faster version of
% the code. If this occurs, D will be returned as the empty matrix. You may
% force the code to forgo the D matrix even for small P and Q by calling the
% function with the optional 3rd lmf variable set to 1. You may also force
% the function to return the D matrix by setting lmf to 0.
%
% Performance Note: Including the lmf input increases the speed of the
% algorithm by avoiding the overhead associated with checking memory
% availability. For the lmf=0 case, this may represent a sizeable
% percentage of the entire run-time.
%
%
% 
% %%% ZCD Oct 2009 %%%
% Edits ZCD: Added the matrix of distances as an output. Fixed bug that
%   would cause an error if one of the sets was a single point. Removed
%   excess calls to "size" and "length". - May 2010
% Edits ZCD: Allowed for comparisons of N-dimensions. - June 2010
% Edits ZCD: Added large matrix mode to avoid insufficient memory errors
%   and a user input to control this mode. - April 2012
% Edits ZCD: Using bsxfun rather than repmat in large matrix mode to
%   increase performance speeds. [update recommended by Roel H on MFX] -
%   October 2012.
%

sP = size(P); sQ = size(Q);

if ~(sP(2)==sQ(2))
    error('Inputs P and Q must have the same number of columns')
end

if nargin == 3
    % the user has specified the large matrix flag one way or the other
    largeMat = lmf;     
    if ~(largeMat==1 || largeMat==0)
        error('3rd ''lmf'' input must be 0 or 1')
    end
else
    largeMat = 1;  
end

if largeMat
% we cannot save all distances, so loop through every point saving only
% those that are the best value so far

sumP = 0;           % initialize our max value
% loop through all points in P looking for maxes
for p = 1:sP(1)
    % calculate the minimum distance from points in P to Q
    minP = min(sum( bsxfun(@minus,P(p,:),Q).^2, 2));
    sumP = sumP + minP;
end
% repeat for points in Q
sumQ = 0;
for q = 1:sQ(1)
    minQ = min(sum( bsxfun(@minus,Q(q,:),P).^2, 2));   
    sumQ = sumQ + minQ;
end
hd = sqrt(sumP / sP(1)) + sqrt(sumQ / sQ(1));
D = [];
    
else
% we have enough memory to build the distance matrix, so use this code
    
% obtain all possible point comparisons
iP = repmat(1:sP(1),[1,sQ(1)])';
iQ = repmat(1:sQ(1),[sP(1),1]);
combos = [iP,iQ(:)];

% get distances for each point combination
cP=P(combos(:, 1), :); cQ=Q(combos(:, 2), :);
dist2s = sum((cP - cQ).^2, 2);

% Now create a matrix of distances where D(n,m) is the distance of the nth
% point in P from the mth point in Q. The maximum distance from any point
% in Q from P will be max(D,[],1) and the maximum distance from any point
% in P from Q will be max(D,[],2);
D = reshape(dist2s, sP(1), []);

% Obtain the value of the point, p, in P with the largest minimum distance
% to any point in Q.
vp = sqrt(sum(min(D,[],2)) / sQ(1));
% Obtain the value of the point, q, in Q with the largets minimum distance
% to any point in P.
vq = sqrt(sum(min(D,[],1)) / sP(1));

hd = sum(vp,vq);

end